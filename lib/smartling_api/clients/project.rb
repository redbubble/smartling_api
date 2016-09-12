require 'faraday'
require 'faraday_middleware'
require 'json'

module SmartlingApi
  module Clients
    class Project
      SMARTLING_API = "https://api.smartling.com"

      def initialize(token:)
        @token = token
      end

      def details(project_id:)
        response = connection.get("/projects-api/v2/projects/#{project_id}", {}, header)

        response.body.fetch("response", {}).fetch("data")
      end

    private

      attr_reader :token

      def header
        { 'Authorization' => "Bearer #{token}", content_type: 'application/json', accept: 'application/json' }
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
