require 'spec_helper'
require 'smartling_api/project.rb'
require 'smartling_api/clients/smartling.rb'

RSpec.describe SmartlingApi::Project, type: :repository do
  describe '#list_locales' do
    subject(:list_locales) { repository.list_locales }

    before do
      stub_request(:get, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/projects-api/v2/projects/Skeletor").
        with(headers: {'Authorization' => "Bearer she-ra"}).
        to_return(
          headers: { 'Content-type' => 'application/json'},
          body: '{
            "response": {
              "code": "SUCCESS",
              "data": {
                "projectId": "Teela",
                "projectName": "Shera",
                "targetLocales": [
                  { "localeId": "de-DE", "description": "German (Germany)" },
                  { "localeId": "es-ES", "description": "Spanish (Spain)" },
                  { "localeId": "fr-FR", "description": "French (France)" }
                ]
              }
            }
          }'
        )
    end

    let(:repository) { described_class.new(token: 'she-ra', project_id: 'Skeletor') }

    it 'returns a list of locale languages' do
      locales = {
        "locales" => [
          { "localeId" => "de-DE", "description" => "German (Germany)" },
          { "localeId" => "es-ES", "description" => "Spanish (Spain)" },
          { "localeId" => "fr-FR", "description" => "French (France)" }
        ]
      }
      expect(list_locales).to eq locales
    end
  end
end
