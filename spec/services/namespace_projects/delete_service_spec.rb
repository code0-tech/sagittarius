# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceProjects::DeleteService do
  subject(:service_response) { described_class.new(create_authentication(current_user), namespace_project).execute }

  let!(:namespace) { create(:namespace) }
  let!(:namespace_project) { create(:namespace_project, namespace: namespace) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceProject.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceProject.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespaceProjectPolicy, :delete_namespace_project, user: current_user,
                                                                              subject: namespace_project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(namespace_project) }
    it { expect { service_response }.to change { NamespaceProject.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :namespace_project_deleted,
        author_id: current_user.id,
        entity_id: namespace_project.id,
        entity_type: 'NamespaceProject',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
