require 'faraday'
require 'faraday_middleware'
require 'smartling_api/errors/not_found'

module Errors
  class RaiseError < Faraday::Response::Middleware
    ERRORS = {
      404 => NotFound
    }

    def on_complete(response)
      if ERRORS.include?(response.status)
        raise ERRORS.fetch(response.status, {}), get_message(response)
      end
    end

    private

    def get_message(response)
      errors = JSON.parse(response.body).fetch("response", {}).fetch("errors", {})

      errors[0].fetch("message", {}) if errors.any?
    end
  end
end
