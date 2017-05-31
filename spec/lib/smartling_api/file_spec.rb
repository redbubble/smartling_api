require 'spec_helper'
require 'smartling_api/file.rb'
require 'smartling_api/clients/smartling.rb'

RSpec.describe SmartlingApi::File do
  let(:file) { described_class.new(token: token, project_id: project_id) }
  let(:project_id) { 'Orko' }
  let(:token)      { 'Skeletor' }

  describe '#list_files' do
    subject(:list_files) { file.list_files(limit: 10) }

    before do
      stub_request(:get, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/files-api/v2/projects/#{project_id}/files/list?limit=10").
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

    it 'returns a list of items' do
      items = [ {
        "fileUri"         => "[/Beast_Man/translate/lift.heavy]",
        "lastUploaded"    => "[2016-09-12 10:51:48 +1000]",
        "fileType"        => "[plainText]",
        "hasInstructions" => "false"
      }]

      expect(list_files).to eq items
    end
  end

  describe '#upload' do
    subject(:upload) { file.upload(file_path: 'en_US', file_uri: 'graceskull', file_type: 'plaintext') }

    before do
      allow(Faraday::UploadIO).to receive(:new).with('en_US', 'text/plain') { file_data }

      stub_request(:post, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/files-api/v2/projects/#{project_id}/file").
        with(headers: {'Authorization' => "Bearer #{token}"}, body: {'file' => file_data, 'fileUri' => 'graceskull', 'fileType' => 'plaintext'}).
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
    end

    let(:file_data) { "by the power of graceskull" }
    let(:client_upload) do
      {
        "code" => "SUCCESS",
        "data" => { "overWritten" => "true", "stringCount" => "5", "wordCount" => "50" }
      }
    end

    it 'returns file contents' do
      expect(upload).to eq client_upload
    end
  end

  describe '#download_locale' do
    subject(:download_locale) { file.download_locale(locale_id: 'en_US', file_uri: 'graceskull') }

    before do
      stub_request(:get, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/files-api/v2/projects/#{project_id}/locales/en_US/file?fileUri=graceskull").
        with(headers: {'Authorization' => "Bearer #{token}"}).
        to_return(
          status: 200,
          headers: {'Content-Disposition' => 'attachment', 'filename' => 'Hordak.po'},
          body: response_body
        )
    end

    let(:response_body) { '{"heman_vs_skeletor": "true"}' }

    it 'returns file contents' do
      expect(download_locale).to eq response_body
    end
  end

  describe '#delete' do
    subject(:delete) { file.delete(file_uri: 'graceskull') }

    before do
     stub_request(:post, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/files-api/v2/projects/#{project_id}/file/delete").
       with(headers: {'Authorization' => "Bearer #{token}"},
            body: { 'fileUri' => 'graceskull' }).
        to_return(
          status: 200,
          headers: { 'Content-type' => 'application/json' },
          body: '{
            "response": {
              "code": "SUCCESS"
            }
          }'
        )
    end

    let(:client_delete) { { 'code' => 'SUCCESS' } }

    it 'returns file contents' do
      expect(delete).to eq client_delete
    end
  end

  describe '#get_translations' do
    subject(:get_translations) { file.get_translations(file_path: 'website.pot', file_uri: 'graceskull', locale_id: 'fr-FR') }

    before do
      allow(Faraday::UploadIO).to receive(:new).with('website.pot', 'text/plain') { file_data }

      stub_request(:post, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/files-api/v2/projects/#{project_id}/locales/fr-FR/file/get-translations").
        with(headers: {'Authorization' => "Bearer #{token}"}, body: {'file' => file_data, 'fileUri' => 'graceskull'}).
        to_return(
          status: 200,
          headers: { 'Content-type' => 'application/text'},
          body: 'msgid "clothing"\nmsgstr "Bekleidung"'
        )
    end

    let(:file_data) { 'msgid: "clothing"\nmsgstr ""' }

    it 'returns file contents' do
      expect(get_translations).to eq "msgid \"clothing\"\\nmsgstr \"Bekleidung\""
    end
  end
end
