# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceProjects::UpdateService do
  subject(:service_response) { described_class.new(current_user, namespace_project, **params).execute }

  let(:namespace) { create(:namespace) }
  let(:namespace_project) { create(:namespace_project, namespace: namespace) }
  let(:namespace_project_name) { generate(:namespace_project_name) }
  let(:params) { { name: namespace_project_name } }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { namespace_project.reload.name } }

    it do
      expect { service_response }.not_to create_audit_event(:namespace_project_updated)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { namespace_project.reload.name } }

    it do
      expect { service_response }.not_to create_audit_event(:namespace_project_updated)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace_project.namespace, user: current_user)
      stub_allowed_ability(NamespaceProjectPolicy, :update_namespace_project, user: current_user,
                                                                              subject: namespace_project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.name).to eq(namespace_project_name) }

    it do
      expect do
        service_response
      end.to change { namespace_project.reload.name }.from(namespace_project.name).to(params[:name])
    end

    it do
      expect { service_response }.to create_audit_event(
        :namespace_project_updated,
        author_id: current_user.id,
        entity_id: namespace_project.id,
        entity_type: 'NamespaceProject',
        details: { name: namespace_project_name },
        target_id: namespace_project.id,
        target_type: 'NamespaceProject'
      )
    end
  end
end
