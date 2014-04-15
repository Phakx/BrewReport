module ApplicationHelper

  require 'open-uri'
  require 'nokogiri'
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def self.import_downtimes_from_icinga(url, username, password, customer)
    Rails.logger.debug 'Begin Fetching Icinga SLA Report'
    uri = URI.parse(url)
    Rails.logger.debug "URI IS: #{uri}"
    begin
      unparsed_xml = open(uri.to_s, :http_basic_authentication => [username, password])
      Rails.logger.debug "unparsed xml: #{unparsed_xml}"
    rescue => e
      Rails.logger.debug e.message
    end
    xml = Nokogiri::XML(unparsed_xml) do |config|
      config.strict.nonet
    end
    #xml = Nokogiri::XML(open('test/helpers/sampleReport.xml'))
    Rails.logger.info 'Fetched XML starting to parse'
    log_entries = xml.xpath('//log_entry')
    Rails.logger.debug "Found #{log_entries.size} Log entries"
    log_entries.each do |entry|
      Rails.logger.debug 'Creating new Downtime object'
      create_new_downtime(entry, customer)
    end
  end

  def self.create_new_downtime(entry, customer)
    start_datetime = Time.at(entry.xpath('start_time_timestamp').text.to_i).to_datetime
    end_datetime = Time.at(entry.xpath('end_time_timestamp').text.to_i).to_datetime
    sla_per_day = find_or_create_sla_per_day(start_datetime.day, start_datetime.month, start_datetime.year, customer)
    Rails.logger.debug 'Checking if Downtime already exists'
    #TODO extend check to include Customer (2 customers can have the same Dowmtimes theoretically...),when the Downtime -> Service -> Slaperday abstraction is
    #implemented check has to be extendended to service as well
    if Downtime.check_if_downtime_exists(start_datetime, end_datetime,sla_per_day.id).nil?
      downtime = Downtime.new
      Rails.logger.debug "Using sla_per_day with id: #{sla_per_day.id} for new Downtime"
      downtime.sla_per_day = sla_per_day
      downtime.start = start_datetime
      downtime.end = end_datetime
      downtime.downtime_type = entry.xpath('entry_type').text
      downtime.comment = entry.xpath('state_information').text
      downtime.save
    else
      Rails.logger.debug("Downtime for #{start_datetime}  till   #{end_datetime}   already exists:")
    end
  end

  def self.find_or_create_sla_per_day(day, month, year, customer)
    sla_per_day = lambda { |sla_per_month|
      daily_sla = SlaPerDay.new
      daily_sla.day=day
      daily_sla.sla_per_month = sla_per_month
      daily_sla.save
      return daily_sla
    }

    Rails.logger.debug "Trying to find Sla_per_day object for #{day} / #{month} / #{year} // #{customer}"
    sla_per_month = SlaPerMonth.retrieve_by_month_and_year(month, year, customer.id)
    if sla_per_month.nil?

      Rails.logger.info 'no matching month object found creating new Month and day object'
      sla_per_month_new = SlaPerMonth.new
      sla_per_month_new.month= month
      sla_per_month_new.year = year
      sla_per_month_new.customer = customer

      if sla_per_month_new.save
        return sla_per_day.call(sla_per_month_new)
      else
        Rails.logger.error(sla_per_month_new.errors.inspect)
        Rails.logger.error 'Persisting Object to Database failed'
        return nil
      end

    else
      Rails.logger.debug 'found sla_per_month object fetching day objects'
      sla_per_days = SlaPerDay.retrieve_all_by_sla_per_month(sla_per_month.id)

      sla_per_days.each do |daily_sla|
        Rails.logger.info 'searching for persisted matching SLA object'
        Rails.logger.debug "ID=  #{daily_sla.id} DAY= #{daily_sla.day} expected day= #{day}"
        if daily_sla.id != '' && (daily_sla.day == day)
          Rails.logger.debug 'found match'
          return daily_sla
        end
      end

      Rails.logger.info 'No match found creating new SlaPerDay and persisting'
      return sla_per_day.call(sla_per_month)

    end

  end

end
