require 'spec_helper'
require 'smartling_api/configuration'

RSpec.describe SmartlingApi do
  describe '#configure' do
    before do
      SmartlingApi.configure do |config|
        config.id     = 'by the powers'
        config.secret = 'Zodac'
      end
    end

    it 'will store smartling id' do
      expect(described_class.configuration.id).to eq 'by the powers'
    end

    it 'will store smartling secret' do
      expect(described_class.configuration.secret).to eq 'Zodac'
    end
  end
end
