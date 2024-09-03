# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::BaseService do

  let(:service) {
    described_class.new
  }

  subject(:service_response) { service.execute }

  context '#identity_provider' do
    before do
      setting = ApplicationSetting.last
      setting.value = [{id: :google, type: :google, config: {}}]
      setting.save
    end

    it 'applies the right providers' do
      providers = service.identity_provider.providers
      expect(providers["google"]).not_to be_nil
      expect(providers.length).to eq(1)
    end

  end


end
