require 'smartling_api/clients/project'
require 'smartling_api/repositories/authentication'

module SmartlingApi
  module Repositories
    class Project

      def initialize(client: project_client, token: token, project_id:)
        @client     = client
        @token      = token
        @project_id = project_id
      end

      def list_locales
        { "locales" => client.details.fetch("targetLocales", []) }
      end

    private

      attr_reader :client, :token, :project_id

      def project_client
        Clients::Project.new(token: token, project_id: project_id)
      end

      def token
        Repositories::Authentication.new.access_token
      end
    end
  end
end
