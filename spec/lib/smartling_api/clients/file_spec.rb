require 'spec_helper'
require 'smartling_api/clients/file.rb'
require 'json'

RSpec.describe SmartlingApi::Clients::File, type: :client do
  let(:project_id)  { "She-Ra" }
  let(:client)      { described_class.new(token: token) }
  let(:token)       { "Battle Cat" }

  describe "#list_files" do
    subject(:file_list) { client.list_files(project_id: project_id) }

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

  describe "#upload" do

    context "When the response is successful" do
      subject(:upload_file) do
        client.upload(
          project_id: project_id,
          file: file,
          fileUri: fileUri,
          fileType: file_type,
          options_key: "heman_value"
        )
      end

      let(:file)      { "He_man_secrets.yml" }
      let(:file_path) { "Etheria" }
      let(:file_type) { "yaml" }
      let(:fileUri)   { "Etheria/He_man_secrets.yml" }

      before do
        stub_request(:post, "#{described_class::SMARTLING_API}/files-api/v2/projects/#{project_id}/file").
        with(headers: {'Authorization' => "Bearer #{token}"},
            body: {'file' => file, 'fileUri' => fileUri, 'fileType' => file_type, 'options_key' => 'heman_value'}).
        to_return(
          status: 200,
          headers: { 'Content-type' => 'application/json'},
          body: '{
            "response": {
              "code": "SUCCESS",
              "data": {
                "overWritten": "true",
                "stringCount": "5",
                "wordCount": "50"
              }
            }
          }'
        )

        allow(Faraday::UploadIO).to receive(:new).with(file, 'text/plain') { file }
      end

      it "uploads the given .pot file" do
        expect(upload_file.body.fetch("response").fetch("code")).to eq "SUCCESS"
      end
    end
  end

  describe "#download_file" do
    subject(:download_file) { client.download_file(project_id: project_id, locale_id: locale_id, fileUri: fileUri, options_key: "heman_value") }
    let(:locale_id)         { "King_Randor" }
    let(:filename)          { "Hordak.po" }
    let(:fileUri)           { "randor/Hordak.po" }
    let(:response_body)     { '{"heman_vs_skeletor": "true"}' }

    context "when a locale is given" do
      before do
        stub_request(:get, "#{described_class::SMARTLING_API}/files-api/v2/projects/#{project_id}/locales/#{locale_id}/file?fileUri=#{fileUri}&options_key=heman_value").
        with(headers: {'Authorization' => "Bearer #{token}"}).
        to_return(
          status: 200,
          headers: {'Content-Disposition' => 'attachment', 'filename' => "#{filename}"},
          body: response_body
        )
      end

      it "downloads the given file" do
        expect(download_file).to eq response_body
      end
    end
  end
end
