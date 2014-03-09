module ApplicationHelper

  require 'open-uri'
  require 'nokogiri'

  def import_downtimes_from_icinga(url, username, password)
    jasper_xml = Nokogiri::XML::Document.parse(open(url, :http_basic_authentication=>[username, password]))

  end
end
