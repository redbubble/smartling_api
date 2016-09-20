require 'smartling_api/authentication'
require 'smartling_api/clients/smartling'

module SmartlingApi
  class Project
    def initialize(smartling: smartling_client, token: access_token, project_id: current_project_id)
      @smartling  = smartling
      @token      = token
      @project_id = project_id
    end

    def list_locales
      locales = smartling.get(url: "/projects-api/v2/projects/#{project_id}", token: token).fetch("targetLocales", [])

      { "locales" => locales }
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
