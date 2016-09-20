require "spec_helper"
require 'smartling_api/errors/raise_error.rb'
require 'smartling_api/errors/not_found.rb'

RSpec.describe Errors::RaiseError do
  describe "#on_complete" do
    subject(:on_complete) { described_class.new.on_complete(response) }
    let(:body) do
      '{
        "response": {
          "errors": [{
            "message": "He-man rulz"
          }]
        }
      }'
    end

    context "when status is 404" do
      let(:response) { double(status: 404, body: body) }

      it "raises a not found error" do
        expect { on_complete }.to raise_error Errors::NotFound
      end
    end

    context "when status is 200" do
      let(:response) { double(status: 200, body: {}) }

      it "does nothing" do
        expect { on_complete }.to_not raise_error
      end
    end
  end
end
