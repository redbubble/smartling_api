require 'spec_helper'
require 'smartling_api/clients/file.rb'
require 'json'

RSpec.describe SmartlingApi::Clients::File, type: :client do
  describe "#list_files" do
    subject(:file_list) { client.list_files(project_id: project_id) }

    let(:client)      { described_class.new(token: token) }
    let(:project_id)  { "She-Ra" }
    let(:token)       { "Battle Cat" }
    let(:items)       {
                        [{
                          "fileUri"=>"[/Beast_Man/translate/lift.heavy]",
                          "lastUploaded"=>"[2016-09-12 10:51:48 +1000]",
                          "fileType"=>"[plainText]",
                          "hasInstructions"=>"false"
                        }]
                      }
    let(:totalCount)  { 1 }


    before do
      stub_request(:get, "#{described_class::SMARTLING_API}/files-api/v2/projects/#{project_id}/files/list").
        with(headers: {'Authorization' => "Bearer #{token}"}).
        to_return(
          headers: { 'Content-type' => 'application/json'},
          body: '{
            "response": {
              "code": "SUCCESS",
              "data": {
                "totalCount": 1,
                "items": [{
                  "fileUri": "[/Beast_Man/translate/lift.heavy]",
                  "lastUploaded": "[2016-09-12 10:51:48 +1000]",
                  "fileType": "[plainText]",
                  "hasInstructions": "false"
                }]
              }
            }
          }'
        )
    end

    context "When response is successful" do

      it "returns items" do
        expect( file_list.fetch("items") ).to eq items
      end

      it "returns totalCount" do
        expect( file_list.fetch("totalCount") ).to eq totalCount
      end

    end
  end
end
