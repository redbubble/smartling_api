require 'spec_helper'
require 'smartling_api/repositories/file.rb'
require 'smartling_api/clients/file.rb'

RSpec.describe SmartlingApi::Repositories::File, type: :repository do
  let(:repository) { described_class.new(client: client, token: 'Skeletor', project_id: project_id) }
  let(:project_id) { 'Orko' }

  describe '#list_files' do
    subject(:list_files) { repository.list_files }

    let(:client)     { instance_double(SmartlingApi::Clients::File, list_files: client_list_files) }
    let(:client_list_files) do
      {
        "totalCount" => 1,
        "items" => [{
          "fileUri"         => "[/Beast_Man/translate/lift.heavy]",
          "lastUploaded"    => "[2016-09-12 10:51:48 +1000]",
          "fileType"        => "[plainText]",
          "hasInstructions" => "false"
        }]
      }
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
    subject(:upload) { repository.upload(file_path: 'en_US', file_uri: 'graceskull', file_type: 'plaintext') }

    let(:client)        { instance_double(SmartlingApi::Clients::File, upload: client_upload) }
    let(:client_upload) do
      {
        "code" => "SUCCESS",
        "data" => {
          "overWritten" => "true",
          "stringCount" => "5",
          "wordCount" => "50"
        }
      }
    end

    it 'returns file contents' do
      expect(upload).to eq client_upload
    end
  end

  describe '#download_locale' do
    subject(:download_locale) { repository.download_locale(locale_id: 'en_US', file_uri: 'graceskull') }

    let(:client)                 { instance_double(SmartlingApi::Clients::File, download_locale: client_download_locale) }
    let(:client_download_locale) { '{"heman_vs_skeletor": "true"}' }

    it 'returns file contents' do
      expect(download_locale).to eq client_download_locale
    end
  end

  describe '#delete' do
    subject(:delete) { repository.delete(file_uri: 'graceskull') }

    let(:client)        { instance_double(SmartlingApi::Clients::File, delete: client_delete) }
    let(:client_delete) { { 'code' => 'SUCCESS' } }

    it 'returns file contents' do
      expect(delete).to eq client_delete
    end
  end
end
