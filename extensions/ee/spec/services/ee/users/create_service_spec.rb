# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::CreateService do
  subject(:service_response) do
    described_class.new(
      create_authentication(current_user),
      username: 'newuser',
      email: 'new@example.com',
      password: 'password123'
    ).execute
  end

  let(:current_user) { create(:user, :admin) }

  it { expect(described_class).to include_module(EE::Users::CreateService) }

  context 'when user limit of license is reached' do
    before do
      current_user
      create(:license, restrictions: { user_count: 0 })
    end

    it { is_expected.not_to be_success }
    it { expect { service_response }.not_to change { User.count } }
    it { expect(service_response.payload[:error_code]).to eq(:no_free_license_seats) }
  end
end
