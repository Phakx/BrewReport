module ApplicationHelper

  require 'open-uri'
  require 'nokogiri'

  def self.import_downtimes_from_icinga(url, username, password)
    logger = Logger.new(STDOUT)
    logger.debug 'Begin Fetching Icinga SLA Report'
    #jasper_xml = Nokogiri::XML(open(url, :http_basic_authentication => [username, password])) do |config|
    #  config.strict.nonet
    #end
    jasper_xml = Nokogiri::XML(open('/home/bjoern/RubymineProjects/sampleReport.xml'))
    logger.debug 'Fetched XML starting to parse'
    log_entries = jasper_xml.xpath('//log_entry')
    logger.debug "Found #{log_entries.size} Log entries"
    log_entries.each do |entry|
      logger.debug 'Creating new Downtime object'
      create_new_downtime(entry, logger)
    end
  end

  def self.create_new_downtime(entry, logger)
    downtime = Downtime.new
    start_datetime = Time.at(entry.xpath('start_time_timestamp').text.to_i).to_datetime
    sla_per_day = SlaPerMonthsHelper.find_or_create_sla_per_day(start_datetime.day, start_datetime.month, start_datetime.year)
    logger.debug "Using #{sla_per_day} for downtime: #{downtime}"
    downtime.sla_per_day = sla_per_day
    downtime.start = start_datetime
    downtime.end = Time.at(entry.xpath('end_time_timestamp').text.to_i).to_datetime
    downtime.downtimeType = entry.xpath('entry_type').text
    downtime.comment = entry.xpath('state_information').text
    downtime.save
  end

  private :self.create_new_downtime
end
