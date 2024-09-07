# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::LoginService do
  subject(:service_response) { service.execute }

  let(:service) do
    described_class.new(provider_id, args)
  end

  def setup_identity_provider(identity)
    provider = service.identity_provider
    allow(service).to receive(:identity_provider).and_return provider
    allow(provider).to receive(:load_identity).and_return identity
  end

  context 'when the credentials are correct' do
    let(:provider_id) { :google }
    let(:args) { { code: 'valid_code' } }
    let!(:current_user) { create(:user) }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, 'identifier', 'username', 'test@code0.tech',
                                                              'firstname', 'lastname')
      create(:user_identity, user: current_user, identifier: 'identifier', provider_id: provider_id)
    end

    it do
      is_expected.to create_audit_event(
        :user_logged_in,
        author_id: current_user.id,
        entity_type: 'User',
        entity_id: current_user.id,
        details: { provider_id: provider_id.to_s, identifier: 'identifier' },
        target_type: 'User',
        target_id: current_user.id
      )
    end

    it do
      expect(service_response).to be_success
      expect(service_response.payload).to be_a(UserSession)
      expect(service_response.payload.user.id).to eq(current_user.id)
      expect(service_response.payload.token).to be_present
    end
  end

  context 'when user identity validation fails' do
    let(:provider_id) { :google }
    let(:args) { { code: 'invalid_code' } }

    before do
      provider = service.identity_provider
      allow(service).to receive(:identity_provider).and_return provider
      allow(provider).to receive(:load_identity).and_raise(Code0::Identities::Error.new('Validation failed'))
    end

    it do
      is_expected.not_to create_audit_event
      expect(service_response).not_to be_success
      expect(service_response.payload.message).to eq('Validation failed')
      expect(service_response.message).to eq('An error occurred while loading external identity')
    end
  end

  context 'when user identity returns null' do
    let(:provider_id) { :google }
    let(:args) { { code: 'invalid_code' } }

    before do
      setup_identity_provider nil
    end

    it do
      is_expected.not_to create_audit_event
      expect(service_response).not_to be_success
      expect(service_response.payload).to eq(:invalid_external_identity)
      expect(service_response.message).to eq('External identity is nil')
    end
  end

  context 'when user identity does not match' do
    let(:provider_id) { :google }
    let(:args) { { code: 'invalid_code' } }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, 'identifier', 'username', 'test@code0.tech',
                                                              'firstname', 'lastname')
    end

    it do
      is_expected.not_to create_audit_event
      expect(service_response).not_to be_success
      expect(service_response.payload).to eq(:external_identity_does_not_exist)
      expect(service_response.message).to eq('No user with that external identity exists, please register first')
    end
  end
end
