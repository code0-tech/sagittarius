# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::RegisterService do
  subject(:service_response) { service.execute }

  let(:service) do
    described_class.new(provider_id, args)
  end
  let(:provider_id) do
    :google
  end
  let(:args) do
    {
      code: 'valid_code',
    }
  end

  def setup_identity_provider(identity)
    provider = service.identity_provider
    allow(service).to receive(:identity_provider).and_return provider
    allow(provider).to receive(:load_identity).and_return identity
  end

  before do
    setup_identity_provider(
      Code0::Identities::Identity.new(
        provider_id,
        'identifier',
        'username',
        'test@code0.tech',
        'firstname',
        'lastname'
      )
    )
  end

  it { expect(described_class).to include_module(EE::Users::Identity::RegisterService) }

  context 'when user limit of license is reached' do
    before do
      stub_application_settings(user_registration_enabled: true)
      create(:license, restrictions: { user_count: 0 })
    end

    it { is_expected.not_to be_success }
    it { expect { service_response }.not_to change { User.count } }
    it { expect(service_response.payload[:error_code]).to eq(:no_free_license_seats) }
  end
end
