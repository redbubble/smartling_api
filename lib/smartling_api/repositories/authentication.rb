require 'smartling_api/clients/smartling'

module SmartlingApi
  module Repositories
    class Authentication

      def initialize(smartling: smartling_client, id: id, secret: secret)
        @smartling   = smartling
        @user_id     = id
        @user_secret = secret
      end

      def access_token
        data = smartling.authenticate(url: '/auth-api/v2/authenticate', body: { userIdentifier: user_id, userSecret: user_secret })

        data.fetch("accessToken")
      end

    private

      attr_reader :smartling, :user_id, :user_secret

      def smartling_client
        Clients::Smartling
      end

      def id
        ENV.fetch("SMARTLING_ID")
      end

      def secret
        ENV.fetch("SMARTLING_SECRET")
      end
    end
  end
end
