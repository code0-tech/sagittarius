# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::DeleteService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), user).execute
  end

  let(:user) { create(:user) }
  let(:current_user) { create(:user, :admin) }
  let!(:ghost_user) do
    create(:user, username: User::GHOST_USERNAME, email: User::GHOST_EMAIL)
  end

  it 'deletes the user successfully' do
    expect { service_response }.to change { User.exists?(user.id) }.from(true).to(false)
    expect(service_response).to be_success
    expect(service_response.payload).to eq(user)

    is_expected.to create_audit_event(
      :user_deleted,
      author_id: current_user.id,
      entity_type: 'User',
      entity_id: user.id,
      details: {},
      target_type: 'global',
      target_id: 0
    )
  end

  context 'when the user authored audit events' do
    let!(:audit_event) do
      create(:audit_event,
             author: user,
             action_type: :user_logged_in,
             entity: user,
             target: AuditEvent::GLOBAL_TARGET)
    end

    it 'reassigns authored audit events to the ghost user' do
      expect { service_response }.to change { User.exists?(user.id) }.from(true).to(false)
      expect(service_response).to be_success
      expect(audit_event.reload.author).to eq(ghost_user)
    end
  end

  context 'when the user owns a namespace' do
    let!(:namespace) { user.ensure_namespace }
    let!(:project) { create(:namespace_project, namespace: namespace) }
    let!(:flow) { create(:flow, project: project) }

    it 'deletes the owned namespace and associated projects and flows' do
      expect { service_response }
        .to change { Namespace.exists?(namespace.id) }.from(true).to(false)
        .and change { NamespaceProject.exists?(project.id) }.from(true).to(false)
        .and change { Flow.exists?(flow.id) }.from(true).to(false)

      expect(service_response).to be_success
    end
  end

  context 'when deleting the current user' do
    let(:user) { current_user }

    it 'creates the deletion audit event with the ghost user as author' do
      expect(service_response).to be_success

      is_expected.to create_audit_event(
        :user_deleted,
        author_id: ghost_user.id,
        entity_type: 'User',
        entity_id: user.id,
        details: {},
        target_type: 'global',
        target_id: 0
      )
    end
  end

  context 'when deleting the ghost user' do
    let(:user) { ghost_user }

    it 'returns an invalid user error' do
      expect(service_response).not_to be_success
      expect(service_response.payload[:error_code]).to eq(:invalid_user)
      expect(User.exists?(ghost_user.id)).to be true
    end
  end

  context 'when current user lacks permission' do
    let(:current_user) { create(:user) }

    it 'returns a missing permission error' do
      expect(service_response).not_to be_success
      expect(service_response.payload[:error_code]).to eq(:missing_permission)
      expect(User.exists?(user.id)).to be true
      is_expected.not_to create_audit_event(:user_deleted)
    end
  end
end
