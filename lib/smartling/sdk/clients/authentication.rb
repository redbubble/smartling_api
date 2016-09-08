require 'faraday'
require 'faraday_middleware'
require 'json'

module Smartling
  module Sdk
    module Clients
      class Authentication
        SMARTLING_API = "https://api.smartling.com"

        def initialize(id:, secret:)
          @id     = id
          @secret = secret
        end

        def authenticate
          response = connection.post('/auth-api/v2/authenticate', body, headers)
          response.body.fetch("response", {}).fetch("data")
        end

        private

        attr_reader :id, :secret

        def body
          JSON({ userIdentifier: id, userSecret: secret })
        end

        def headers
          { content_type: 'application/json', accept: 'application/json' }
        end

        def connection
          Faraday.new(url: SMARTLING_API) do |faraday|
            faraday.adapter :net_http
            faraday.request :json

            faraday.response :json, content_type: /\bjson$/
          end
        end
      end
    end
  end
end
