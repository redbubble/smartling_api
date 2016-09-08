require 'spec_helper'
require 'smartling/sdk/clients/authentication.rb'
require 'json'

RSpec.describe Smartling::Sdk::Clients::Authentication, type: :client do
  describe '#authenticate' do
    subject(:authenticate) { authentication.authenticate }

    let(:authentication)      { described_class.new(id: id, secret: secret) }
    let(:id)                  { "matte" }
    let(:secret)              { "letmein" }

    before do
      stub_request(:post, "#{described_class::SMARTLING_API}/auth-api/v2/authenticate").
        with(body: JSON({ "userIdentifier" => id, "userSecret" => secret } )).
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

    it "returns an access token" do
      expect(authenticate.fetch("accessToken")).to eq "123456"
    end

    it "returns a refresh token" do
      expect(authenticate.fetch("refreshToken")).to eq "654321"
    end
  end
end
