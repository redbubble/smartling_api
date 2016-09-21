require 'faraday'
require 'faraday_middleware'
require 'smartling_api/errors/not_found'
require 'smartling_api/errors/client'
require 'smartling_api/errors/internal_server'
require 'smartling_api/errors/unprocessable_entity'

module SmartlingApi
  module Errors
    # Middleware for Faraday error handling
    class RaiseError < Faraday::Response::Middleware
      # Mapping of Smartling Error response
      ERRORS = {
        404 => NotFound,
        422 => UnprocessableEntity,
        500 => InternalServer
      }

      # Hook for faraday middleware to respond to errors.
      # Will raise mapped error, but will default to using Errors::Client.
      #
      # @param response [Faraday::Response] Response object passed from middleware
      # @return [nil] If no errors
      # @raise [Errors::Client] Specific error raised depending on response status code.
      def on_complete(response)
        return if response.status < 400

        raise ERRORS.fetch(response.status, Client), get_message(response)
      end

      private

      def get_message(response)
        return "" if response.body.nil? || response.body.empty?

        errors = JSON.parse(response.body).fetch("response", {}).fetch("errors", {})

        errors.map { |error| error["message"] }.join(", ")
      end
    end
  end
end
