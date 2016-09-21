module SmartlingApi
  Configuration = Struct.new(:id, :secret, :project_id) do

    # Check if id and secrets have been set
    # @return [Boolean]
    def invalid?
      id.nil? || secret.nil?
    end
  end

  class << self
    # A Struct containing configuration values
    # @return [Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Yield current configuration
    # This is so the config can be set as,
    #
    # @example configure
    #   SmartlingApi::configure do |config|
    #     config.id = "ABC"
    #     config.secret = "DEF"
    #     config.project_id = "GHI"
    #   end
    def configure
      yield(configuration)
    end
  end
end
