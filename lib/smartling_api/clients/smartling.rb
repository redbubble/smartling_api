require 'faraday'
require 'faraday_middleware'
require 'smartling_api/errors/raise_error'

module SmartlingApi
  module Clients
    # Client used to contact smartling api
    class Smartling
      SMARTLING_API = "https://api.smartling.com"

      # Get request used to contact Smartling API
      #
      # @param url [String] Path corresponding to API get request
      # @param token [String] OAuth2 token used for accessing endpoint
      # @param params [Hash] Additional parameters to pass with request
      # @return [Hash] Data returned from request
      # @raise [Errors::Client] If response does not return a 2xx or 3xx
      def get(url:, token:, params: {})
        response = connection.get(url, params, header(token))
        response.body.fetch("response", {}).fetch("data")
      end

      # Post request used to contact Smartling API
      #
      # @param url [String] Path corresponding to API get request
      # @param token [String] OAuth2 token used for accessing endpoint
      # @param body [Hash] Request body to pass with request
      # @return [Hash] Response returned from request
      # @raise [Errors::Client] If response does not return a 2xx or 3xx
      def post(url:, token:, body:)
        response = connection.post(url, body, header(token))
        response.body.fetch("response", {})
      end

      # Authentication request used to contact Smartling API.  Need to pass
      # Smartling id and secret with the request. This is the only request
      # that does not use a token in request.
      #
      # @param url [String] Path corresponding to API get request
      # @param body [Hash] Request body to pass with request
      # @return [Hash] Data returned from request
      # @raise [Errors::Client] If response does not return a 2xx or 3xx
      def authenticate(url:, body:)
        response = connection.post(url, body, {})
        response.body.fetch("response", {}).fetch("data")
      end

      # Upload a file using a multipart request
      #
      # @param url [String] Path corresponding to API get request
      # @param token [String] OAuth2 token used for accessing endpoint
      # @param body [Hash] Request body to pass with request
      # @return [Hash] Response returned from request
      # @raise [Errors::Client] If response does not return a 2xx or 3xx
      def upload(url:, token:, body:)
        multipart_connection.post(url, body, header(token)).body.fetch('response')
      end

      # Download a file from smartling for the given url
      #
      # @param url [String] Path corresponding to API get request
      # @param token [String] OAuth2 token used for accessing endpoint
      # @param params [Hash] Request params to pass with request
      # @return [Hash] Response returned from request
      # @raise [Errors::Client] If response does not return a 2xx or 3xx
      def download(url:, token:, params:)
        response = connection.get(url, params, header(token))
        response.body
      end

    private

      def header(token)
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
