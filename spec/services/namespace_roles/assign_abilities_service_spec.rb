# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRoles::AssignAbilitiesService do
  subject(:service_response) { described_class.new(create_authentication(current_user), role, abilities).execute }

  let(:current_user) { create(:user) }
  let(:role) { create(:namespace_role) }
  let(:abilities) { [] }

  let!(:admin_role) do
    create(:namespace_role, namespace: role.namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRoleAbility.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user does not have permission' do
    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRoleAbility.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user has permission' do
    context 'when ability is last admin ability' do
      context 'when namespace is an user' do
        let(:abilities) { [] }
        let(:role) { create(:namespace_role, namespace: create(:namespace, :user)) }

        before do
          stub_allowed_ability(NamespacePolicy, :assign_role_abilities, user: current_user, subject: role.namespace)
          create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
          admin_role.delete
        end

        it { is_expected.to be_success }
        it { expect { service_response }.to change { NamespaceRoleAbility.count }.by(-1) }

        it do
          expect { service_response }.to create_audit_event(:namespace_role_abilities_updated)
        end
      end

      context 'when namespace is an organization' do
        let(:abilities) { [] }

        before do
          stub_allowed_ability(NamespacePolicy, :assign_role_abilities, user: current_user, subject: role.namespace)
          create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
          admin_role.delete
        end

        it { is_expected.not_to be_success }
        it { expect(service_response.payload).to eq(:cannot_remove_last_admin_ability) }
        it { expect { service_response }.not_to change { NamespaceRoleAbility.count } }

        it do
          expect { service_response }.not_to create_audit_event
        end
      end
    end

    context 'when adding an ability' do
      let(:abilities) { [:create_namespace_role] }

      before do
        stub_allowed_ability(NamespacePolicy, :assign_role_abilities, user: current_user, subject: role.namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(['create_namespace_role']) }
      it { expect { service_response }.to change { NamespaceRoleAbility.count }.by(1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_role_abilities_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'NamespaceRole',
          details: { 'old_abilities' => [],
                     'new_abilities' => ['create_namespace_role'] },
          target_id: role.namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when removing an ability' do
      let(:abilities) { [] }

      before do
        create(:namespace_role_ability, namespace_role: role, ability: :create_namespace_role)
        stub_allowed_ability(NamespacePolicy, :assign_role_abilities, user: current_user, subject: role.namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to be_empty }
      it { expect { service_response }.to change { NamespaceRoleAbility.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_role_abilities_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'NamespaceRole',
          details: { 'old_abilities' => ['create_namespace_role'],
                     'new_abilities' => [] },
          target_id: role.namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when adding and removing an ability' do
      let(:abilities) { [:create_namespace_role] }

      before do
        create(:namespace_role_ability, namespace_role: role, ability: :invite_member)
        stub_allowed_ability(NamespacePolicy, :assign_role_abilities, user: current_user, subject: role.namespace)
      end

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(['create_namespace_role']) }
      it { expect { service_response }.not_to change { NamespaceRoleAbility.count } }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_role_abilities_updated,
          author_id: current_user.id,
          entity_id: role.id,
          entity_type: 'NamespaceRole',
          details: {
            'old_abilities' => ['invite_member'],
            'new_abilities' => ['create_namespace_role'],
          },
          target_id: role.namespace.id,
          target_type: 'Namespace'
        )
      end
    end
  end
end
