# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::LinkService do
  subject(:service_response) { service.execute }

  let(:service) do
    described_class.new(create_authentication(current_user), provider_id, args)
  end

  def setup_identity_provider(identity)
    provider = service.identity_provider
    allow(service).to receive(:identity_provider).and_return provider
    allow(provider).to receive(:load_identity).and_return identity
  end

  context 'when user is valid' do
    let(:provider_id) { :google }
    let(:args) { { code: 'valid_code' } }
    let(:current_user) { create(:user) }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, 'identifier', 'username', 'test@code0.tech',
                                                              'firstname', 'lastname')
    end

    it do
      expect { service_response }.to change { current_user.reload.user_identities.length }.by(1)
      expect(service_response).to be_success
    end

    it 'creates the audit event' do
      expect { service_response }.to create_audit_event(
        :user_identity_linked,
        entity_type: 'User',
        details: { 'provider_id' => provider_id.to_s, 'identifier' => 'identifier' },
        target_type: 'User'
      )
    end
  end

  context 'when user already has the same external identity with same identifier and provider id' do
    let(:provider_id) { :google }
    let(:args) { { code: 'valid_code' } }
    let(:current_user) { create(:user) }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, 'identifier', 'username', 'test@code0.tech',
                                                              'firstname', 'lastname')
      create(:user_identity, provider_id: provider_id, identifier: 'identifier', user: current_user)
    end

    it do
      expect(service_response).not_to be_success
      expect(service_response.payload[:details].full_messages).to include('Identifier has already been taken')
    end

    it 'does not create the audit event' do
      expect { service_response }.not_to create_audit_event
    end
  end
end
