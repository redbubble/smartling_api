require 'smartling/sdk/clients/authentication'

module Smartling
  module Sdk
    module Repositories
      class Authentication

        def initialize(client: authentication_client)
          @client = client
        end

        def access_token
          client.authenticate.fetch("accessToken")
        end

      private

        attr_reader :client

        def authentication_client
          Clients::Authentication.new(id: ENV.fetch("SMARTLING_ID"), secret: ENV.fetch("SMARTLING_SECRET"))
        end
      end
    end
  end
end
