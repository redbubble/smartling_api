require 'faraday'
require 'faraday_middleware'
require 'json'

module SmartlingApi
  module Clients
    class File
      SMARTLING_API = "https://api.smartling.com"

      def initialize(token:, project_id:)
        @token      = token
        @project_id = project_id
      end

      def list_files(**options)
        response = connection.get("/files-api/v2/projects/#{project_id}/files/list", options, header)

        response.body.fetch("response", {}).fetch("data")
      end

      def upload(file_path:, file_uri:, file_type:, **options)
        body = {
          file:     Faraday::UploadIO.new(file_path, 'text/plain'),
          fileUri:  file_uri,
          fileType: file_type
        }.merge(options)

        multipart_connection.post("/files-api/v2/projects/#{project_id}/file", body, header).body.fetch('response')
      end

      def download_locale(locale_id:, file_uri:, **options)
        body = { fileUri: file_uri }.merge(options)

        response = connection.get("/files-api/v2/projects/#{project_id}/locales/#{locale_id}/file", body, header)
        response.body
      end

      def delete(file_uri:)
        connection.post("files-api/v2/projects/#{project_id}/file/delete", { fileUri: file_uri }, header).body.fetch('response')
      end

    private

      attr_reader :token, :project_id

      def header
        { 'Authorization' => "Bearer #{token}" }
      end

      def multipart_connection
        Faraday.new(url: SMARTLING_API) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded

          faraday.response :json, content_type: /\bjson$/

          faraday.adapter :net_http
        end
      end

      def connection
        Faraday.new(url: SMARTLING_API) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/

          faraday.adapter :net_http
        end
      end
    end
  end
end
