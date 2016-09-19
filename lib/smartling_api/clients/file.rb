require 'faraday'
require 'faraday_middleware'
require 'json'

module SmartlingApi
  module Clients
    class File
      SMARTLING_API = "https://api.smartling.com"

      def initialize(token:)
        @token = token
      end

      def list_files(project_id:, **options)
        response = connection.get("/files-api/v2/projects/#{project_id}/files/list", options, header)

        response.body.fetch("response", {}).fetch("data")
      end

      def upload(project_id:, file:, fileUri:, fileType:, **options)
        body = {
          file:     Faraday::UploadIO.new(file, 'text/plain'),
          fileUri:  fileUri,
          fileType: fileType
        }.merge(options)

        multipart_connection.post("/files-api/v2/projects/#{project_id}/file", body, header)
      end

      def download_file(project_id:, locale_id:, fileUri:, **options)
        body = { fileUri: fileUri }.merge(options)

        response = connection.get("/files-api/v2/projects/#{project_id}/locales/#{locale_id}/file", body, header)
        response.body
      end

      def delete(project_id:, file_uri:)
        connection.post("files-api/v2/projects/#{project_id}/file/delete", { fileUri: file_uri }, header)
      end

    private

      attr_reader :token

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
