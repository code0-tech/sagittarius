# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::UpdateService do
  subject(:service_response) { described_class.new(current_user, runtime, params).execute }

  shared_examples 'does not update' do
    it { is_expected.to be_error }

    it 'does not update organization' do
      expect { service_response }.not_to change { runtime.reload.name }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:runtime) { create(:runtime) }
    let(:params) do
      { name: generate(:runtime_name) }
    end

    it_behaves_like 'does not update'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user, admin: true) }
    let(:runtime) { create(:runtime) }

    context 'when name is to long' do
      let(:params) { { name: generate(:runtime_name) + ('*' * 50) } }

      it_behaves_like 'does not update'
    end

    context 'when name is to short' do
      let(:params) { { name: 'a' } }

      it_behaves_like 'does not update'
    end
  end

  context 'when user and params are valid and user is admin' do
    let(:current_user) { create(:user, admin: true) }
    let(:runtime) { create(:runtime) }
    let(:params) do
      { name: generate(:runtime_name) }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates runtime' do
      expect { service_response }.to change { runtime.reload.name }.from(runtime.name).to(params[:name])
    end

    it do
      is_expected.to create_audit_event(
        :runtime_updated,
        author_id: current_user.id,
        entity_type: 'Runtime',
        details: { name: params[:name] },
        target_type: 'global'
      )
    end
  end

  context 'when user and params are valid and namespace is present' do
    let(:current_user) { create(:user) }
    let(:runtime) { create(:runtime, namespace: create(:namespace)) }
    let(:params) do
      { name: generate(:runtime_name) }
    end

    before do
      stub_allowed_ability(NamespacePolicy, :update_runtime, user: current_user, subject: runtime.namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates runtime' do
      expect { service_response }.to change { runtime.reload.name }.from(runtime.name).to(params[:name])
    end

    it do
      is_expected.to create_audit_event(
        :runtime_updated,
        author_id: current_user.id,
        entity_type: 'Runtime',
        details: { name: params[:name] },
        target_type: 'Namespace'
      )
    end
  end
end
