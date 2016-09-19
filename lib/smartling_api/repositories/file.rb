require 'smartling_api/clients/file'
require 'smartling_api/repositories/authentication'

module SmartlingApi
  module Repositories
    class File

      def initialize(client: file_client, token: token, project_id:)
        @client     = client
        @token      = token
        @project_id = project_id
      end

      def list_files(**options)
        client.list_files(**options).fetch("items")
      end

      def download_locale(locale_id:, file_uri:, **options)
        client.download_locale(locale_id: locale_id, file_uri: file_uri, **options)
      end

      def upload(file_path:, file_uri:, file_type:, **options)
        client.upload(file_path: file_path, file_uri: file_uri, file_type: file_type, **options)
      end

      def delete(file_uri:)
        client.delete(file_uri: file_uri)
      end

    private

      attr_reader :client, :token, :project_id

      def file_client
        Clients::File.new(token: token, project_id: project_id)
      end

      def token
        Repositories::Authentication.new.access_token
      end
    end
  end
end
