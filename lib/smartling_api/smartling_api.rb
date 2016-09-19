require 'smartling_api/version'

module SmartlingApi
  Configuration = Struct.new(:id, :secret)

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
