# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Members::BulkInviteService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), namespace, users).execute
  end

  let(:namespace) { create(:namespace) }
  let(:users) { create_list(:user, 2) }
  let(:current_user) { create(:user) }

  context 'when user has permission' do
    before do
      stub_allowed_ability(NamespacePolicy, :invite_member, user: current_user, subject: namespace)
    end

    it 'creates an audit event for every invited member' do
      expect { service_response }.to change {
        AuditEvent.where(action_type: :namespace_member_invited).count
      }.by(users.count)

      events = AuditEvent.where(
        action_type: :namespace_member_invited,
        entity_type: 'NamespaceMember'
      )

      expect(events.pluck(:entity_id)).to match_array(service_response.payload.map(&:id))
      expect(events).to all(
        have_attributes(
          author_id: current_user.id,
          details: {},
          target_id: namespace.id,
          target_type: 'Namespace'
        )
      )
    end
  end
end
