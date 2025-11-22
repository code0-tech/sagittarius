# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DeleteService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), user).execute
  end

  let(:user) { create(:user) }
  let(:current_user) { create(:user, :admin) }

  it 'deletes the user successfully' do
    expect { service_response }.to change { User.exists?(user.id) }.from(true).to(false)
    expect(service_response).to be_success
    expect(service_response.payload).to eq(user)

    is_expected.to create_audit_event(
      :user_deleted,
      author_id: current_user.id,
      entity_type: 'User',
      entity_id: user.id,
      details: {},
      target_type: 'global',
      target_id: 0
    )
  end

  context 'when current user lacks permission' do
    let(:current_user) { create(:user) }

    it 'returns a missing permission error' do
      expect(service_response).not_to be_success
      expect(service_response.payload[:error_code]).to eq(:missing_permission)
      expect(User.exists?(user.id)).to be true
      is_expected.not_to create_audit_event(:user_deleted)
    end
  end
end
