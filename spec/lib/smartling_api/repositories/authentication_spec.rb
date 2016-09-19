require 'spec_helper'
require 'smartling_api/repositories/authentication.rb'
require 'smartling_api/clients/smartling.rb'

RSpec.describe SmartlingApi::Repositories::Authentication, type: :repository do
  describe '#access_token' do
    subject(:access_token) { repository.access_token }

    before do
      stub_request(:post, "#{SmartlingApi::Clients::Smartling::SMARTLING_API}/auth-api/v2/authenticate").
        with(body: JSON({ "userIdentifier" => 'he-man', "userSecret" => 'skeletor' } )).
        to_return(
          headers: { 'Content-type' => 'application/json' },
          body: '{
            "response": {
              "code": "SUCCESS",
              "data": {
                "accessToken": "123456",
                "refreshToken": "654321"
              }
            }
          }'
        )
    end

    let(:repository)    { described_class.new(configuration: configuration) }
    let(:configuration) { double(invalid?: false, id: 'he-man', secret: 'skeletor') }

    it 'will return the token' do
      expect(access_token).to eq "123456"
    end

    context 'when user has not supplied smartling configuration' do
      let(:configuration) { double(invalid?: true) }

      it 'will raise credentials error' do
        expect { access_token }.to raise_error Errors::Credentials
      end
    end
  end
end
