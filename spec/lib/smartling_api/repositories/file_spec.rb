require 'spec_helper'
require 'smartling_api/repositories/file.rb'
require 'smartling_api/clients/file.rb'

RSpec.describe SmartlingApi::Repositories::File, type: :repository do
  describe '#list_files' do
    subject(:list_files) { repository.list_files(project_id: 'Orko') }

    let(:repository) { described_class.new(client: client, token: 'Skeletor') }
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
end
