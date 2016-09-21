require 'faraday'
require 'smartling_api/clients/smartling'
require 'smartling_api/authentication'

module SmartlingApi
  # Access to Smartling Files API
  class File
    def initialize(smartling: smartling_client, token: access_token, project_id: current_project_id)
      @token      = token
      @project_id = project_id
      @smartling  = smartling.new(token: token)
    end

    # Access to Smartling files api to retrieve list of files for a given project
    #
    # @see http://docs.smartling.com/pages/API/v2/FileAPI/List/
    #
    # @example List Files
    #   SmartlingApi::File.new.list_files(uriMask: '.json') #=> [{"fileUri" => "[/translate/file.json]", ...}]
    #
    # @param options [Hash] Additional options for the given request.
    # @return [Array] A list of files matching the criteria
    def list_files(**options)
      files = smartling.get(url: "/files-api/v2/projects/#{project_id}/files/list", params: options)
      files.fetch("items")
    end

    # Access to Smartling files api to download a file for a given locale id
    #
    # @see http://docs.smartling.com/pages/API/v2/FileAPI/Download-File/Single-Locale/
    #
    # @example Download file
    #   SmartlingApi::File.new.download_locale(locale_id: 'fr-Fr', file_uri: '/translation/website') #=> "translations"
    #
    # @param locale_id [String] Locale id for the given file
    # @param file_uri [String] File path within smartling
    # @param options [Hash] Additional options for the given request.
    # @return [String] Contents of the specified file
    def download_locale(locale_id:, file_uri:, **options)
      params = { fileUri: file_uri }.merge(options)

      smartling.download(url: "/files-api/v2/projects/#{project_id}/locales/#{locale_id}/file", params: params)
    end

    # Access to Smartling files api to upload a file
    #
    # @see http://docs.smartling.com/pages/API/v2/FileAPI/Upload-File/
    #
    # @example Upload file
    #   SmartlingApi::File.new.upload(file_path: 'website.pot', file_uri: '/translation/website', file_type: 'gettext') #=> { "code" => "SUCCESS" }
    #
    # @param file_path [String] Location of file to upload
    # @param file_uri [String] File path within smartling
    # @param file_type [String] Type of file to upload
    # @param options [Hash] Additional options for the given request.
    # @return [Hash] Details of upload
    def upload(file_path:, file_uri:, file_type:, **options)
      body = {
        file:     Faraday::UploadIO.new(file_path, 'text/plain'),
        fileUri:  file_uri,
        fileType: file_type
      }.merge(options)

      smartling.upload(url: "/files-api/v2/projects/#{project_id}/file", body: body)
    end

    # Access to Smartling files api to delete a file
    #
    # @see http://docs.smartling.com/pages/API/v2/FileAPI/Delete/
    #
    # @example List Files
    #   SmartlingApi::File.new.delete(file_uri: '/translations/website') #=> { "code" => "SUCCESS" }
    #
    # @param file_uri [String] File path within Smartling to delete
    # @return [Hash] Details for file deletion
    def delete(file_uri:)
      smartling.post(url: "/files-api/v2/projects/#{project_id}/file/delete", body: { fileUri: file_uri })
    end

  private

    attr_reader :smartling, :token, :project_id

    def current_project_id
      SmartlingApi.configuration.project_id
    end

    def smartling_client
      Clients::Smartling
    end

    def access_token
      Authentication.new.access_token
    end
  end
end
