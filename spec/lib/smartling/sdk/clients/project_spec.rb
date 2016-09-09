require 'spec_helper'
require 'smartling/sdk/clients/project.rb'
require 'json'

RSpec.describe Smartling::Sdk::Clients::Project, type: :client do
  describe "#details" do
    subject(:details) { client.details(project_id: project_id) }

    let(:client)      { described_class.new(token: token) }
    let(:project_id)  { "ManAtArms" }
    let(:token)       { "Orko" }

    before do
      stub_request(:get, "#{described_class::SMARTLING_API}/auth-api/v2/projects/#{project_id}").
        with(headers: {'Authorization' => "Bearer #{token}"}).
        to_return(
          headers: { 'Content-type' => 'application/json'},
          body: '{
            "response": {
              "code": "SUCCESS",
              "data": {
                "projectId": "Teela",
                "projectName": "Shera",
                "targetLocales": [
                  { "localeId": "de-DE", "description": "German (Germany)" }
                ]
              }
            }
          }'
        )
    end

    it "returns projectName" do
      expect(details.fetch("projectName")).to eq "Shera"
    end
  end
end
