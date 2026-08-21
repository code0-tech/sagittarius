# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::CreateService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), namespace, name, **params).execute
  end

  let(:namespace) { nil }
  let(:name) { generate(:runtime_name) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create runtime' do
      expect { service_response }.not_to change { Runtime.count }
    end

    it { expect { service_response }.not_to create_audit_event }
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

  context 'when namespace has a project without a primary runtime' do
    let(:namespace) { create(:namespace) }
    let(:current_user) { create(:user) }
    let(:params) do
      { name: generate(:runtime_name) }
    end
    let!(:project) { create(:namespace_project, namespace: namespace) }

    before do
      stub_allowed_ability(NamespacePolicy, :create_runtime, user: current_user, subject: namespace)
    end

    it 'assigns the created runtime as the primary runtime' do
      service_response
      expect(project.reload.primary_runtime).to eq(service_response.payload)
    end

    it 'assigns the created runtime to the project' do
      service_response
      expect(project.reload.runtimes).to contain_exactly(service_response.payload)
    end
  end

  context 'when namespace already has a runtime' do
    let(:namespace) { create(:namespace) }
    let(:current_user) { create(:user) }
    let(:params) do
      { name: generate(:runtime_name) }
    end
    let!(:existing_runtime) { create(:runtime, namespace: namespace) }
    let!(:project) { create(:namespace_project, namespace: namespace, primary_runtime: existing_runtime) }

    before do
      stub_allowed_ability(NamespacePolicy, :create_runtime, user: current_user, subject: namespace)
    end

    it 'does not change the primary runtime of existing projects' do
      expect { service_response }.not_to(change { project.reload.primary_runtime })
    end
  end

  context 'when project in namespace already has a primary runtime' do
    let(:namespace) { create(:namespace) }
    let(:current_user) { create(:user) }
    let(:params) do
      { name: generate(:runtime_name) }
    end
    let!(:other_runtime) { create(:runtime) }
    let!(:project) { create(:namespace_project, namespace: namespace, primary_runtime: other_runtime) }

    before do
      stub_allowed_ability(NamespacePolicy, :create_runtime, user: current_user, subject: namespace)
    end

    it 'does not change the primary runtime' do
      expect { service_response }.not_to(change { project.reload.primary_runtime })
    end
  end

  context 'when user and params are valid and user is admin' do
    let(:current_user) { create(:user, :admin) }
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
