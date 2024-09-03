# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceMembers::DeleteService do
  subject(:service_response) { described_class.new(current_user, namespace_member).execute }

  let(:namespace) { create(:namespace) }
  let!(:namespace_member) { create(:namespace_member, namespace: namespace) }
  let!(:admin_role) do
    create(:namespace_role, namespace: namespace).tap do |role|
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
      create(:namespace_member_role, role: role)
    end
  end
  let!(:admin) do
    create(:namespace_member, namespace: namespace).tap do |member|
      create(:namespace_member_role, member: member, role: admin_role)
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceMember.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceMember.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is the last admin' do
    context 'when namespace is an user' do
      let(:namespace) { create(:namespace, :user) }
      let(:current_user) { create(:user) }

      before do
        create(:namespace_member, namespace: namespace, user: current_user)
        stub_allowed_ability(NamespacePolicy, :delete_member, user: current_user, subject: namespace)
        admin.delete
        admin_role.delete
      end

      it { is_expected.to be_success }
      it { expect { service_response }.to change { NamespaceMember.count }.by(-1) }

      it do
        expect { service_response }.to create_audit_event(
          :namespace_member_deleted,
          author_id: current_user.id,
          entity_type: 'NamespaceMember',
          details: {},
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      end
    end

    context 'when namespace is a organization' do
      let(:current_user) { create(:user) }

      before do
        create(:namespace_member, namespace: namespace, user: current_user)
        stub_allowed_ability(NamespacePolicy, :delete_member, user: current_user, subject: namespace)
        admin.delete
        admin_role.delete
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.payload).to eq(:cannot_remove_last_administrator) }
      it { expect { service_response }.not_to change { NamespaceMember.count } }

      it do
        expect { service_response }.not_to create_audit_event
      end
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :delete_member, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect { service_response }.to change { NamespaceMember.count }.by(-1) }

    it do
      expect { service_response }.to create_audit_event(
        :namespace_member_deleted,
        author_id: current_user.id,
        entity_type: 'NamespaceMember',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
