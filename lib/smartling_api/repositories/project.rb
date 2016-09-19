require 'smartling_api/repositories/authentication'
require 'smartling_api/clients/smartling'

module SmartlingApi
  module Repositories
    class Project
      def initialize(smartling: smartling_client, token: access_token, project_id:)
        @smartling  = smartling
        @token      = token
        @project_id = project_id
      end

      def list_locales
        locales = smartling.get(url: "/projects-api/v2/projects/#{project_id}", token: token).fetch("targetLocales", [])

        { "locales" => locales }
      end

    private

      attr_reader :smartling, :token, :project_id

      def smartling_client
        Clients::Smartling
      end

      def access_token
        Repositories::Authentication.new.access_token
      end
    end
  end
end
