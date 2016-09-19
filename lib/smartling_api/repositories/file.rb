require 'faraday'
require 'smartling_api/clients/smartling'
require 'smartling_api/repositories/authentication'

module SmartlingApi
  module Repositories
    class File
      def initialize(smartling: smartling_client, token: access_token, project_id:)
        @smartling  = smartling
        @token      = token
        @project_id = project_id
      end

      def list_files(**options)
        files = smartling.get(url: "/files-api/v2/projects/#{project_id}/files/list", params: options, token: token)
        files.fetch("items")
      end

      def download_locale(locale_id:, file_uri:, **options)
        params = { fileUri: file_uri }.merge(options)

        smartling.download(url: "/files-api/v2/projects/#{project_id}/locales/#{locale_id}/file", params: params, token: token)
      end

      def upload(file_path:, file_uri:, file_type:, **options)
        body = {
          file:     Faraday::UploadIO.new(file_path, 'text/plain'),
          fileUri:  file_uri,
          fileType: file_type
        }.merge(options)

        smartling.upload(url: "/files-api/v2/projects/#{project_id}/file", body: body, token: token)
      end

      def delete(file_uri:)
        smartling.post(url: "/files-api/v2/projects/#{project_id}/file/delete", body: { fileUri: file_uri }, token: token)
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
