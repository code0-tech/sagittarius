# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceProjects::CreateService do
  subject(:service_response) { described_class.new(current_user, **params).execute }

  let(:namespace) { create(:namespace) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create project' do
      expect { service_response }.not_to change { NamespaceProject.count }
    end

    it { expect { service_response }.not_to create_audit_event(:namespace_project_created) }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { namespace: namespace, name: generate(:namespace_project_name) }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { namespace: namespace, name: generate(:namespace_project_name) + ('*' * 50) } }

      it_behaves_like 'does not create'
    end

    context 'when name is to short' do
      let(:params) { { namespace: namespace, name: 'a' } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:params) do
      { namespace: namespace, name: generate(:namespace_project_name) }
    end

    before do
      stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :namespace_project_created,
        author_id: current_user.id,
        entity_type: 'NamespaceProject',
        details: {
          name: params[:name],
        },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
