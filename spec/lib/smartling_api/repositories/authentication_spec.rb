require 'spec_helper'
require 'smartling_api/repositories/authentication.rb'
require 'smartling_api/clients/authentication.rb'

RSpec.describe SmartlingApi::Repositories::Authentication, type: :repository do
  describe '#access_token' do
    subject(:access_token) { repository.access_token }

    let(:repository)            { described_class.new(client: authentication_client) }
    let(:authentication_client) { instance_double(SmartlingApi::Clients::Authentication, authenticate: authenticate) }
    let(:authenticate) do
      {
        "accessToken" => "123456",
        "refreshToken" => "654321"
      }
    end

    it 'will return the token' do
      expect(access_token).to eq "123456"
    end
  end
end
