require 'smartling_api/clients/project'
require 'smartling_api/repositories/authentication'

module SmartlingApi
  module Repositories
    class Project

      def initialize(client: project_client, token: token)
        @client = client
        @token  = token
      end

      def list_locales(project_id:)
        { "locales" => client.details(project_id: project_id).fetch("targetLocales", []) }
      end

    private

      attr_reader :client, :token

      def project_client
        Clients::Project.new(token: token)
      end

      def token
        Repositories::Authentication.new.access_token
      end
    end
  end
end
