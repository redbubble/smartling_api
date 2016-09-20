require 'smartling_api/clients/smartling'
require 'smartling_api/configuration'
require 'smartling_api/errors/credentials'

module SmartlingApi
  module Repositories
    class Authentication

      def initialize(smartling: smartling_client, configuration: SmartlingApi.configuration)
        @smartling     = smartling
        @configuration = configuration
      end

      def access_token
        raise Errors::Credentials if configuration.invalid?
        data = smartling.authenticate(url: '/auth-api/v2/authenticate', body: { userIdentifier: user_id, userSecret: user_secret })

        data.fetch("accessToken")
      end

    private

      attr_reader :smartling, :configuration

      def smartling_client
        Clients::Smartling
      end

      def user_id
        configuration.id
      end

      def user_secret
        configuration.secret
      end
    end
  end
end
