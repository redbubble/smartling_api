require 'smartling_api/authentication'
require 'smartling_api/clients/smartling'

module SmartlingApi
  # Access to Smartling Project API
  class Project
    def initialize(smartling: smartling_client, token: access_token, project_id: current_project_id)
      @token      = token
      @project_id = project_id
      @smartling  = smartling
    end

    # Access to Smartling project api to retrieve list of locales available
    #
    # @see http://docs.smartling.com/pages/API/v2/Projects/List-Projects/
    #
    # @example List Files
    #   SmartlingApi::Project.new.list_locales #=> [{ "localeId" => "de-DE", "description" => "German (Germany)" }, ...]
    #
    # @return [Array] Details of the locales available
    def list_locales
      smartling.get(url: "/projects-api/v2/projects/#{project_id}", token: token).fetch("targetLocales", [])
    end

  private

    attr_reader :smartling, :token, :project_id

    def current_project_id
      SmartlingApi.configuration.project_id
    end

    def smartling_client
      Clients::Smartling.new
    end

    def access_token
      Authentication.new.access_token
    end
  end
end
