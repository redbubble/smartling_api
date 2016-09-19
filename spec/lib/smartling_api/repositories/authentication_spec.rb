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

    let(:repository)  { described_class.new(id: 'he-man', secret: 'skeletor') }

    it 'will return the token' do
      expect(access_token).to eq "123456"
    end
  end
end
