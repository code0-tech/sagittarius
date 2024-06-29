# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::CreateService do
  subject(:service_response) { described_class.new(current_user, namespace, name, **params).execute }

  let(:namespace) { nil }
  let(:name) { generate(:runtime_name) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create runtime' do
      expect { service_response }.not_to change { Runtime.count }
    end

    it { expect { service_response }.not_to create_audit_event(:runtime_created) }
  end

  context 'when runtime does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { name: generate(:runtime_name) }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { name: generate(:runtime_name) + ('*' * 50) } }

      it_behaves_like 'does not create'
    end

    context 'when name is to short' do
      let(:params) { { name: 'a' } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid and namespace is not null' do
    let(:namespace) { create(:namespace) }
    let(:current_user) { create(:user) }
    let(:params) do
      { name: generate(:runtime_name) }
    end

    before do
      stub_allowed_ability(NamespacePolicy, :create_runtime, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :runtime_created,
        author_id: current_user.id,
        entity_type: 'Runtime',
        details: { name: params[:name] },
        target_type: 'Namespace',
        target_id: namespace.id
      )
    end
  end

  context 'when user and params are valid and user is admin' do
    let(:current_user) { create(:user, admin: true) }
    let(:params) do
      { name: generate(:runtime_name) }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :runtime_created,
        author_id: current_user.id,
        entity_type: 'Runtime',
        details: { name: params[:name] },
        target_type: 'global'
      )
    end
  end
end
