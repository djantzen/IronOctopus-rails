module IronOctopus
  class Configuration

    @@instance = nil

    attr_accessor :application
    attr_accessor :validations

    def initialize
      env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      application_file = File.open(Rails.root.to_s + '/config/application.yml')
      validations_file = File.open(Rails.root.to_s + '/config/validations.yml')

      application_config = YAML.load(application_file)
      validations_config = YAML.load(validations_file)

      self.validations = symbolize_keys(validations_config)
      if application_config[env]
        self.application = application_config[env].symbolize_keys
      end
    end

    def self.instance
      @@instance = Configuration.new if @@instance.nil?
      @@instance
    end

    def symbolize_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
                    when String then key.to_sym
                    else key
                  end
        new_value = case value
                      when Hash then symbolize_keys(value)
                      else value
                    end
        result[new_key] = new_value
        result
      }
    end

  end
end

