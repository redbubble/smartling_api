require 'faraday'
require 'faraday_middleware'
require 'json'

module SmartlingApi
  module Clients
    class Authentication

      SMARTLING_API = "https://api.smartling.com"

      def initialize(id:, secret:)
        @id     = id
        @secret = secret
      end

      def authenticate
        response = connection.post('/auth-api/v2/authenticate', body, {})
        response.body.fetch("response", {}).fetch("data")
      end

    private

      attr_reader :id, :secret

      def body
        { userIdentifier: id, userSecret: secret }
      end

      def headers
        { content_type: 'application/json', accept: 'application/json' }
      end

      def connection
        Faraday.new(url: SMARTLING_API) do |faraday|
          faraday.request :json

          faraday.response :json, content_type: /\bjson$/

          faraday.adapter :net_http
        end
      end
    end
  end
end
