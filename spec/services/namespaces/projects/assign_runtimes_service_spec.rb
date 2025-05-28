# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::AssignRuntimesService do
  subject(:service_response) { described_class.new(create_authentication(current_user), project, runtimes).execute }

  let(:current_user) { create(:user) }
  let(:project) { create(:namespace_project) }
  let(:runtimes) { [] }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceProjectRuntimeAssignment.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceProjectRuntimeAssignment.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user has permission' do
    context 'when adding a runtime' do
      let(:runtimes) { [create(:runtime, namespace: project.namespace)] }

      before do
        stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(project) }
      it { expect { service_response }.to change { NamespaceProjectRuntimeAssignment.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :project_runtimes_assigned,
          author_id: current_user.id,
          entity_id: project.id,
          entity_type: 'NamespaceProject',
          details: {
            'old_runtimes' => [],
            'new_runtimes' => [{ 'id' => runtimes.first.id }],
          },
          target_id: project.id,
          target_type: 'NamespaceProject'
        )
      end
    end

    context 'when removing a project' do
      let(:runtime) { create(:runtime, namespace: project.namespace) }
      let!(:namespace_project_runtime_assignment) do
        create(:namespace_project_runtime_assignment, namespace_project: project, runtime: runtime)
      end
      let(:runtimes) { [] }

      before do
        stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(project) }
      it { expect { service_response }.to change { NamespaceProjectRuntimeAssignment.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :project_runtimes_assigned,
          author_id: current_user.id,
          entity_id: project.id,
          entity_type: 'NamespaceProject',
          details: {
            'old_runtimes' => [{ 'id' => namespace_project_runtime_assignment.runtime.id }],
            'new_runtimes' => [],
          },
          target_id: project.id,
          target_type: 'NamespaceProject'
        )
      end
    end

    context 'when adding and removing a project' do
      let(:runtime) { create(:runtime, namespace: project.namespace) }
      let!(:namespace_project_runtime_assignment) do
        create(:namespace_project_runtime_assignment, namespace_project: project, runtime: runtime)
      end
      let(:runtimes) { [create(:runtime, namespace: project.namespace)] }

      before do
        stub_allowed_ability(NamespaceProjectPolicy, :assign_project_runtimes, user: current_user, subject: project)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(project) }
      it { expect { service_response }.not_to change { NamespaceProjectRuntimeAssignment.count } }

      it do
        expect { service_response }.to create_audit_event(
          :project_runtimes_assigned,
          author_id: current_user.id,
          entity_id: project.id,
          entity_type: 'NamespaceProject',
          details: {
            'old_runtimes' => [{ 'id' => namespace_project_runtime_assignment.runtime.id }],
            'new_runtimes' => [{ 'id' => runtimes.first.id }],
          },
          target_id: project.id,
          target_type: 'NamespaceProject'
        )
      end
    end
  end
end
