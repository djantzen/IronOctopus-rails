class Configuration

  @@instance = nil

  attr_accessor :application

  def initialize
    env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    application_file = File.open('config/application.yml')
    application_config = YAML.load(application_file)
    if application_config[env]
      self.application = application_config[env].symbolize_keys
    end
  end

  def self.instance
    @@instance = Configuration.new if @@instance.nil?
    @@instance
  end

end