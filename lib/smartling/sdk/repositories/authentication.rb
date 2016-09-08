module Smartling
  module Sdk
    module Repositories
      class Authentication
        def self.access_token(client: client)
          client.authenticate.fetch("response", {}).fetch("data", {}).fetch("accessToken")
        end

        private

        def self.client
          Clients::Authentication.new(id: ENV.fetch(:SMARTLING_ID), secret: ENV.fetch(:SMARTLING_SECRET))
        end
      end
    end
  end
end
