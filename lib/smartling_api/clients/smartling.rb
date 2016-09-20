require 'faraday'
require 'faraday_middleware'
require 'smartling_api/errors/raise_error'

module SmartlingApi
  module Clients
    class Smartling
      SMARTLING_API = "https://api.smartling.com"

      class << self
        def header(token)
          { 'Authorization' => "Bearer #{token}" }
        end

        def get(url:, token:, params: {})
          response = connection.get(url, params, header(token))
          response.body.fetch("response", {}).fetch("data")
        end

        def post(url:, body:, token:)
          response = connection.post(url, body, header(token))
          response.body.fetch("response", {})
        end

        def authenticate(url:, body:)
          response = connection.post(url, body, {})
          response.body.fetch("response", {}).fetch("data")
        end

        def upload(url:, body:, token:)
          multipart_connection.post(url, body, header(token)).body.fetch('response')
        end

        def download(url:, params:, token:)
          response = connection.get(url, params, header(token))
          response.body
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
end
