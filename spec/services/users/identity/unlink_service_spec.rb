# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::UnlinkService do
  subject(:service_response) { service.execute }

  let(:service) do
    described_class.new(create_authentication(current_user), identity)
  end

  context 'when user is valid' do
    let(:provider_id) { :google }
    let(:current_user) { create(:user) }
    let!(:identity) { create(:user_identity, user: current_user, identifier: 'identifier', provider_id: :google) }

    it do
      expect { service_response }.to change { current_user.reload.user_identities.length }.by(-1)
      expect(service_response).to be_success
      expect(identity).not_to be_persisted
    end

    it 'creates the audit event' do
      expect { service_response }.to create_audit_event(
        :user_identity_unlinked,
        entity_type: 'User',
        details: { 'provider_id' => provider_id.to_s, 'identifier' => 'identifier' },
        target_type: 'User'
      )
    end
  end
end
