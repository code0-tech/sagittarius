# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRoles::DeleteService do
  subject(:service_response) { described_class.new(create_authentication(current_user), namespace_role).execute }

  let!(:namespace_role) { create(:namespace_role) }
  let!(:admin_role) do
    create(:namespace_role, namespace: namespace_role.namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when role is the last role with the namespace_administrator ability' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace_role.namespace, user: current_user)
      create(:namespace_role_ability, namespace_role: namespace_role, ability: :namespace_administrator)
      stub_allowed_ability(NamespacePolicy, :delete_namespace_role, user: current_user,
                                                                    subject: namespace_role.namespace)
      admin_role.delete
    end

    it { is_expected.not_to be_success }
    it { expect { service_response }.not_to change { NamespaceRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace_role.namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :delete_namespace_role, user: current_user,
                                                                    subject: namespace_role.namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(namespace_role) }
    it { expect { service_response }.to change { NamespaceRole.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :namespace_role_deleted,
        author_id: current_user.id,
        entity_type: 'NamespaceRole',
        details: {},
        target_id: namespace_role.namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
