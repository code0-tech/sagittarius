# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Members::InviteService do
  subject(:service_response) { described_class.new(create_authentication(current_user), namespace, user).execute }

  let(:namespace) { create(:namespace) }
  let(:user) { create(:user) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceMember.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user does not have permission' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceMember.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      stub_allowed_ability(NamespacePolicy, :invite_member, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.namespace).to eq(namespace) }
    it { expect(service_response.payload.user).to eq(user) }
    it { expect { service_response }.to change { NamespaceMember.count }.by(1) }

    it do
      expect { service_response }.to create_audit_event(
        :namespace_member_invited,
        author_id: current_user.id,
        entity_type: 'NamespaceMember',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
