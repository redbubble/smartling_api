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

      def download_locale(project_id:, locale_id:, file_uri:, **options)
        client.download_locale(project_id: project_id, locale_id: locale_id, file_uri: file_uri, **options)
      end

      def upload(project_id:, file_path:, file_uri:, file_type:, **options)
        client.upload(project_id: project_id, file_path: file_path, file_uri: file_uri, file_type: file_type, **options)
      end

      def delete(project_id:, file_uri:)
        client.delete(project_id: project_id, file_uri: file_uri)
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
