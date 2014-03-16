module ApplicationHelper

  require 'open-uri'
  require 'nokogiri'

  def self.import_downtimes_from_icinga(url, username, password)
    logger = Logger.new(STDOUT)
    logger.debug 'Begin Fetching Icinga SLA Report'
    jasper_xml = Nokogiri::XML(open(url, :http_basic_authentication => [username, password])) do |config|
      config.strict.nonet
    end

    logger.debug 'Fetched XML starting to parse'
    log_entries = jasper_xml.xpath('//log_entry')
    logger.debug "Found #{log_entries.size} Log entries"
    log_entries.each do |entry|
      logger.debug 'Creating new Downtime object'
      create_new_downtime(entry, logger)
    end
  end

  def self.find_or_create_sla_per_day(day, month, year)
    logger = Logger.new(STDOUT)
    sla_per_day = lambda { |sla_per_month|
      daily_sla = SlaPerDay.new
      daily_sla.day=day
      daily_sla.sla_per_month = sla_per_month
      daily_sla.save
      return daily_sla
    }

    logger.debug "Trying to find Sla_per_day object for #{day} / #{month} / #{year}"
    sla_per_month = SlaPerMonth.retrieve_by_month_and_year(month, year)
    if sla_per_month.nil?

      logger.debug 'no matching month object found creating new Month and day object'
      sla_per_month_new = SlaPerMonth.new
      sla_per_month_new.month= month
      sla_per_month_new.year = year

      if sla_per_month_new.save
        return sla_per_day.call(sla_per_month_new)
      else
        return nil
      end

    else

      logger.debug 'found sla_per_month object fetching day objects'
      sla_per_days = SlaPerDay.retrieve_all_by_sla_per_month(sla_per_month.id)
      sla_per_days.each do |daily_sla|
        logger.debug 'searching for persisted matching SLA object'
        logger.debug "ID=  #{daily_sla.id} DAY= #{daily_sla.day} expected day= #{day}"
        if daily_sla.id != '' && (daily_sla.day == day)
          logger.debug 'found match'
          return daily_sla
        end
      end
      logger.debug 'No match found creating new SlaPerDay and persisting'
      return sla_per_day.call(sla_per_month)

    end

  end

  def self.create_new_downtime(entry, logger)
    downtime = Downtime.new
    start_datetime = Time.at(entry.xpath('start_time_timestamp').text.to_i).to_datetime
    sla_per_day = find_or_create_sla_per_day(start_datetime.day, start_datetime.month, start_datetime.year)
    logger.debug "Using #{sla_per_day} for downtime: #{downtime}"
    downtime.sla_per_day = sla_per_day
    downtime.start = start_datetime
    downtime.end = Time.at(entry.xpath('end_time_timestamp').text.to_i).to_datetime
    downtime.downtimeType = entry.xpath('entry_type').text
    downtime.comment = entry.xpath('state_information').text
    downtime.save
  end
  private :self.create_new_downtime, :self.find_or_create_sla_per_day
end
