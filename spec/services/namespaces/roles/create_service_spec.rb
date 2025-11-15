# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Roles::CreateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), namespace, params).execute }

  let(:namespace) { create(:namespace) }
  let(:role_name) { generate(:role_name) }
  let(:params) { { name: role_name } }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { NamespaceRole.count } }

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :create_namespace_role, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.namespace).to eq(namespace) }
    it { expect(service_response.payload.name).to eq(role_name) }
    it { expect { service_response }.to change { NamespaceRole.count }.by(1) }

    it do
      expect { service_response }.to create_audit_event(
        :namespace_role_created,
        author_id: current_user.id,
        entity_type: 'NamespaceRole',
        details: { name: role_name },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
