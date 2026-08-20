# Bitget/Configuration.rb
# Bitget::Configuration

module Bitget
  class Configuration
    attr_accessor :api_key, :api_secret, :api_passphrase, :debug, :logger

    def initialize
      @api_key = nil
      @api_secret = nil
      @api_passphrase = nil
      @debug = false
      @logger = nil
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
