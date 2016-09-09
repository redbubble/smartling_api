require 'spec_helper'
require 'smartling/sdk/repositories/authentication.rb'
require 'smartling/sdk/clients/authentication.rb'

RSpec.describe Smartling::Sdk::Repositories::Authentication, type: :repository do
  describe '#acces_token' do
    subject(:access_token) { described_class.access_token(client: client) }

    let(:client) { instance_double(Smartling::Sdk::Clients::Authentication, authenticate: authenticate) }
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
