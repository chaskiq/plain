require "plain/version"
require "plain/engine"
require "plain/configuration"

module Plain
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
