# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegisterService do
  subject(:service_response) do
    described_class.new('testuser', 'test@example.com', 'password123').execute
  end

  it { expect(described_class).to include_module(EE::Users::RegisterService) }

  context 'when user limit of license is reached' do
    before do
      create(:license, restrictions: { user_count: 0 })
    end

    it { is_expected.not_to be_success }
    it { expect { service_response }.not_to change { User.count } }
    it { expect(service_response.payload[:error_code]).to eq(:no_free_license_seats) }
  end
end
