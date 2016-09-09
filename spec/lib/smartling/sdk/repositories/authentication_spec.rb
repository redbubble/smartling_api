require 'spec_helper'
require 'smartling/sdk/repositories/authentication.rb'
require 'smartling/sdk/clients/authentication.rb'

RSpec.describe Smartling::Sdk::Repositories::Authentication, type: :repository do
  describe '#access_token' do
    subject(:access_token) { repository.access_token }

    let(:repository)            { described_class.new(client: authentication_client) }
    let(:authentication_client) { instance_double(Smartling::Sdk::Clients::Authentication, authenticate: authenticate) }
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
