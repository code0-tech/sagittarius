# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::UnlinkService do
  subject(:service_response) { service.execute }

  let(:service) do
    described_class.new(current_user, identity)
  end

  def setup_identity_provider(identity)
    provider = service.identity_provider
    allow(service).to receive(:identity_provider).and_return provider
    allow(provider).to receive(:load_identity).and_return identity
  end

  context 'when user is valid' do
    let(:provider_id) { :google }
    let(:current_user) { create(:user) }
    let(:identity) { create(:user_identity, user: current_user, identifier: 'identifier', provider_id: :google) }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, 'identifier', 'username', 'test@code0.tech',
                                                              'firstname', 'lastname')
    end

    it do
      expect { service_response }.to change { current_user.reload.user_identities.length }.by(-1)
      expect(service_response).to be_success
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
