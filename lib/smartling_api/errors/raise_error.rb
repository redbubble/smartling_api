require 'faraday'
require 'faraday_middleware'
require 'smartling_api/errors/not_found'
require 'smartling_api/errors/client'
require 'smartling_api/errors/internal_server'
require 'smartling_api/errors/unprocessable_entity'

module SmartlingApi
  module Errors
    class RaiseError < Faraday::Response::Middleware
      ERRORS = {
        404 => NotFound,
        422 => UnprocessableEntity,
        500 => InternalServer
      }

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
