# Load the rails application
require File.expand_path('../application', __FILE__)
# Add Tor to the path
ENV['PATH'] = "#{ENV['PATH']}:/usr/sbin"
# Initialize the rails application
IronOctopus::Application.initialize!
