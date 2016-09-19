require 'smartling_api/clients/file'
require 'smartling_api/repositories/authentication'

module SmartlingApi
  module Repositories
    class File

      def initialize(client: file_client, token: token)
        @client = client
        @token  = token
      end

      def list_files(project_id:, **options)
        client.list_files(project_id: project_id, **options).fetch("items")
      end

    private

      attr_reader :client, :token

      def file_client
        Clients::File.new(token: token)
      end

      def token
        Repositories::Authentication.new.access_token
      end
    end
  end
end
