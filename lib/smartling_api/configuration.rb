module SmartlingApi
  Configuration = Struct.new(:id, :secret) do
    def invalid?
      id.nil? || secret.nil?
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
  end
end
