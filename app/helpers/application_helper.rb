module ApplicationHelper

  require 'open-uri'
  require 'nokogiri'

  def self.import_downtimes_from_icinga(url, username, password)

    jasper_xml = Nokogiri::XML(open(url, :http_basic_authentication=>[username, password])) do |config|
      config.strict.nonet
    end
    log_entries = jasper_xml.xpath("//log_entry")
    log_entries.each do |entry|
      downtime = Downtime.new
      downtime.start = Time.at(entry.xpath("start_time_timestamp").text.to_i).to_datetime
      downtime.end = Time.at(entry.xpath("end_time_timestamp").text.to_i).to_datetime
      downtime.downtimeType = entry.xpath("entry_type").text
      downtime.comment = entry.xpath("state_information").text
      downtime.save
    end
  end
end
