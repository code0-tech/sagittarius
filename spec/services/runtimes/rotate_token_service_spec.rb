# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::RotateTokenService do
  subject(:service_response) { described_class.new(current_user, runtime).execute }

  let!(:runtime) { create(:runtime) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { runtime.reload.token } }

    it do
      expect { service_response }.not_to create_audit_event(:runtime_token_rotated)
    end
  end

  context 'when user is a valid and is admin' do
    let(:current_user) { create(:user, admin: true) }

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(runtime) }
    it { expect { service_response }.to change { runtime.reload.token } }

    it do
      expect { service_response }.to create_audit_event(
        :runtime_token_rotated,
        author_id: current_user.id,
        entity_type: 'Runtime',
        details: {},
        target_id: 0,
        target_type: 'global'
      )
    end
  end

  context 'when user is a valid and namespace is present and user has permissions' do
    let(:current_user) { create(:user, admin: true) }
    let(:namespace) do
      create(:namespace).tap do |namespace|
        create(:namespace_member, namespace: namespace, user: current_user)
      end
    end
    let(:runtime) { create(:runtime, namespace: namespace) }

    before do
      stub_allowed_ability(NamespacePolicy, :rotate_runtime_token, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(runtime) }
    it { expect { service_response }.to change { runtime.reload.token } }

    it do
      expect { service_response }.to create_audit_event(
        :runtime_token_rotated,
        author_id: current_user.id,
        entity_type: 'Runtime',
        details: {},
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end
end
