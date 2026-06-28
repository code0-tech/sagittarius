# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DeleteService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), user).execute
  end

  let(:current_user) { create(:user) }
  let(:user) { current_user }
  let(:namespace) { current_user.ensure_namespace }

  before do
    current_user.update!(admin: true)
    create(:user, :admin)
  end

  context 'when the current user has an active subscription' do
    before { create(:license, namespace: namespace, options: { subscription: true }) }

    it 'does not delete the user' do
      expect(described_class.new(create_authentication(current_user), user).deletion_restriction)
        .to eq(:active_subscription)
      expect(service_response).not_to be_success
      expect(service_response.payload[:error_code]).to eq(:cannot_delete_user_with_active_subscription)
      expect(User.exists?(user.id)).to be true
      is_expected.not_to create_audit_event(:user_deleted)
    end
  end

  context 'when another user has an active subscription' do
    let(:user) { create(:user) }

    before { create(:license, namespace: user.ensure_namespace, options: { subscription: true }) }

    it 'allows an administrator to delete the user' do
      expect { service_response }.to change { User.exists?(user.id) }.from(true).to(false)
      expect(service_response).to be_success
    end
  end
end
