# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Roles::AssignProjectsService do
  subject(:service_response) { described_class.new(create_authentication(current_user), role, projects).execute }

  let(:current_user) { create(:user) }
  let(:role) { create(:namespace_role) }
  let(:projects) { [] }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRoleProjectAssignment.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRoleProjectAssignment.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user has permission' do
    context 'when adding a project' do
      let(:projects) { [create(:namespace_project, namespace: role.namespace)] }

      before do
        stub_allowed_ability(NamespacePolicy, :assign_role_projects, user: current_user, subject: role.namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(projects) }
      it { expect { service_response }.to change { NamespaceRoleProjectAssignment.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_role_projects_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'NamespaceRole',
          details: {
            'old_projects' => [],
            'new_projects' => [{ 'id' => projects.first.id, 'name' => projects.first.name }],
          },
          target_id: role.namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when removing a project' do
      let(:projects) { [] }
      let!(:role_assignment) { create(:namespace_role_project_assignment, role: role) }

      before do
        stub_allowed_ability(NamespacePolicy, :assign_role_projects, user: current_user, subject: role.namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to be_empty }
      it { expect { service_response }.to change { NamespaceRoleProjectAssignment.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_role_projects_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'NamespaceRole',
          details: {
            'old_projects' => [{ 'id' => role_assignment.project.id, 'name' => role_assignment.project.name }],
            'new_projects' => [],
          },
          target_id: role.namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when adding and removing a project' do
      let(:projects) { [create(:namespace_project, namespace: role.namespace)] }
      let!(:role_assignment) { create(:namespace_role_project_assignment, role: role) }

      before do
        stub_allowed_ability(NamespacePolicy, :assign_role_projects, user: current_user, subject: role.namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(projects) }
      it { expect { service_response }.not_to change { NamespaceRoleProjectAssignment.count } }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_role_projects_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'NamespaceRole',
          details: {
            'old_projects' => [{ 'id' => role_assignment.project.id, 'name' => role_assignment.project.name }],
            'new_projects' => [{ 'id' => projects.first.id, 'name' => projects.first.name }],
          },
          target_id: role.namespace.id,
          target_type: 'Namespace'
        )
      end
    end
  end
end
