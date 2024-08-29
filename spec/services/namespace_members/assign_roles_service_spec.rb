# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceMembers::AssignRolesService do
  subject(:service_response) { described_class.new(current_user, member, roles).execute }

  let(:current_user) { create(:user) }
  let(:namespace) { create(:namespace) }
  let(:member) { create(:namespace_member, namespace: namespace) }
  let(:roles) { [] }
  let!(:admin_role) do
    create(:namespace_role, namespace: namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
      create(:namespace_member_role, role: role)
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceMemberRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceMemberRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user has permission' do
    context 'when removing last admin role' do
      context 'when namespace is an user' do
        let(:namespace) { create(:namespace, :user) }
        let(:namespace_role) { create(:namespace_role, namespace: namespace) }

        before do
          create(:namespace_member_role, member: member, role: namespace_role)
          stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
          admin_role.delete
        end

        it { is_expected.to be_success }
        it { expect { service_response }.to change { NamespaceMemberRole.count }.by(-1) }

        it do
          expect { service_response }.to create_audit_event(:namespace_member_roles_updated)
        end
      end

      context 'when namespace is an organization' do
        before do
          stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
          admin_role.delete
        end

        it { is_expected.not_to be_success }
        it { expect(service_response.payload).to eq(:cannot_remove_last_administrator) }
        it { expect { service_response }.not_to change { NamespaceMemberRole.count } }

        it do
          expect { service_response }.not_to create_audit_event
        end
      end
    end

    context 'when adding a role' do
      let(:namespace_role) { create(:namespace_role, namespace: namespace) }
      let(:roles) { [namespace_role] }

      before do
        stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([namespace_role]) }
      it { expect { service_response }.to change { NamespaceMemberRole.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'NamespaceMember',
          details: {
            'old_roles' => [],
            'new_roles' => [{ 'id' => namespace_role.id,
                              'name' => namespace_role.name }],
          },
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when removing a role' do
      let(:namespace_role) { create(:namespace_role, namespace: namespace) }
      let(:roles) { [] }

      before do
        create(:namespace_member_role, member: member, role: namespace_role)
        stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([]) }
      it { expect { service_response }.to change { NamespaceMemberRole.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'NamespaceMember',
          details: {
            'old_roles' => [{ 'id' => namespace_role.id,
                              'name' => namespace_role.name }],
            'new_roles' => [],
          },
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when adding and removing a role' do
      let(:adding_namespace_role) { create(:namespace_role, namespace: namespace) }
      let(:removing_namespace_role) { create(:namespace_role, namespace: namespace) }
      let(:roles) { [adding_namespace_role] }

      before do
        create(:namespace_member_role, member: member, role: removing_namespace_role)
        stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload.map(&:role)).to eq([adding_namespace_role]) }
      it { expect { service_response }.not_to change { NamespaceMemberRole.count } }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_member_roles_updated,
          author_id: current_user.id,
          entity_type: 'NamespaceMember',
          details: {
            'old_roles' => [{ 'id' => removing_namespace_role.id,
                              'name' => removing_namespace_role.name }],
            'new_roles' => [{ 'id' => adding_namespace_role.id,
                              'name' => adding_namespace_role.name }],
          },
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when roles and member belong to different namespace' do
      let(:roles) { [create(:namespace_role)] }

      before do
        stub_allowed_ability(NamespacePolicy, :assign_member_roles, user: current_user, subject: namespace)
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.payload).to eq(:inconsistent_namespace) }
      it { expect { service_response }.not_to change { NamespaceMemberRole.count } }

      it do
        expect { service_response }.not_to create_audit_event
      end
    end
  end
end
