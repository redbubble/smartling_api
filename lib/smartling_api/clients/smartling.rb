require 'faraday'
require 'faraday_middleware'
require 'smartling_api/errors/raise_error'

module SmartlingApi
  module Clients
    class Smartling
      SMARTLING_API = "https://api.smartling.com"
      NONE = nil

      def initialize(token: NONE)
        @token = token
      end

      def get(url:, params: {})
        response = connection.get(url, params, header)
        response.body.fetch("response", {}).fetch("data")
      end

      def post(url:, body:)
        response = connection.post(url, body, header)
        response.body.fetch("response", {})
      end

      def authenticate(url:, body:)
        response = connection.post(url, body, {})
        response.body.fetch("response", {}).fetch("data")
      end

      def upload(url:, body:)
        multipart_connection.post(url, body, header).body.fetch('response')
      end

      def download(url:, params:)
        response = connection.get(url, params, header)
        response.body
      end

    private

      attr_reader :token

      def header
        { 'Authorization' => "Bearer #{token}" }
      end

      def connection
        Faraday.new(url: SMARTLING_API) do |faraday|
          faraday.request :json

          faraday.response :json, content_type: /\bjson$/

          faraday.adapter :net_http
          faraday.use Errors::RaiseError
        end
      end

      def multipart_connection
        Faraday.new(url: SMARTLING_API) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded

          faraday.response :json, content_type: /\bjson$/

          faraday.adapter :net_http
          faraday.use Errors::RaiseError
        end
      end
    end
  end
end
