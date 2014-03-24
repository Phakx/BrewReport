# Load the Rails application.
require File.expand_path('../application', __FILE__)
Rails.logger = Logger.new('log/devloment.log')
# Initialize the Rails application.
BrewReport::Application.initialize!
