# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Licenses::CreateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), **params).execute }

  let(:namespace) { create(:namespace) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create namespace license' do
      expect { service_response }.not_to change { NamespaceLicense.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { data: create(:namespace_license).data, namespace: namespace }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when data is invalid' do
      let(:params) { { data: '', namespace: namespace } }

      it_behaves_like 'does not create'
    end

    context 'when namespace is invalid' do
      let!(:params) { { data: create(:namespace_license).data, namespace: nil } }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:license_data) do
      {
        licensee: { 'company' => 'Code0' },
        start_date: (Time.zone.today - 1).to_s,
        end_date: (Time.zone.today + 1).to_s,
        restrictions: {},
        options: {},
      }
    end

    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { data: create(:namespace_license, **license_data).data, namespace: namespace }
    end
    # rubocop:enable RSpec/LetSetup

    before do
      stub_allowed_ability(NamespacePolicy, :create_namespace_license, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'adds license to the namespace' do
      expect { service_response }.to change { NamespaceLicense.where(namespace: namespace).count }.by(1)
    end

    it do
      is_expected.to create_audit_event(
        :namespace_license_created,
        author_id: current_user.id,
        entity_type: 'NamespaceLicense',
        details: license_data,
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
