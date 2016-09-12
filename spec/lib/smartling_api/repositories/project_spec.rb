require 'spec_helper'
require 'smartling_api/repositories/project.rb'
require 'smartling_api/clients/project.rb'

RSpec.describe SmartlingApi::Repositories::Project, type: :repository do
  describe '#list_locales' do
    subject(:list_locales) { repository.list_locales(project_id: 'Orko') }

    let(:repository) { described_class.new(client: client, token: 'Skeletor') }
    let(:client)     { instance_double(SmartlingApi::Clients::Project, details: details) }
    let(:details) do
      {
        "projectId" => "Teela",
        "projectName" => "Shera",
        "targetLocales" => [
          { "localeId" => "de-DE", "description" => "German (Germany)" },
          { "localeId" => "es-ES", "description" => "Spanish (Spain)" },
          { "localeId" => "fr-FR", "description" => "French (France)" }
        ]
      }
    end

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
