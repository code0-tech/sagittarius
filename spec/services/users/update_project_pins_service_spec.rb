# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::UpdateProjectPinsService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), namespace_id, project_ids).execute
  end

  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:organization_namespace) { organization.ensure_namespace }
  let(:project_one) { create(:namespace_project, namespace: organization_namespace) }
  let(:project_two) { create(:namespace_project, namespace: organization_namespace) }
  let(:namespace_id) { organization_namespace.id }
  let(:project_ids) { [project_one.id, project_two.id] }

  before do
    create(:namespace_member, namespace: organization_namespace, user: user)
  end

  context 'when current user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when a project does not exist' do
    let(:current_user) { user }
    let(:project_ids) { [project_one.id, 999_999] }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when the user is not a member of the project namespace' do
    let(:current_user) { user }
    let(:other_project) { create(:namespace_project, namespace: create(:organization).ensure_namespace) }
    let(:project_ids) { [project_one.id, other_project.id] }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
  end

  context 'when a project does not belong to the given namespace' do
    let(:current_user) { user }
    let(:other_project) { create(:namespace_project, namespace: create(:organization).ensure_namespace) }
    let(:project_ids) { [project_one.id, other_project.id] }

    before { create(:namespace_member, namespace: other_project.namespace, user: user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
  end

  context 'when input is valid' do
    let(:current_user) { user }

    it { is_expected.to be_success }

    it 'replaces pins in the given order with sequential priorities' do
      service_response

      pins = user.reload.user_project_pins
      expect(pins.pluck(:project_id)).to eq(project_ids)
      expect(pins.pluck(:priority)).to eq([0, 1])
    end

    it 'creates an audit event' do
      expect { service_response }.to create_audit_event(
        :user_project_pins_updated,
        author_id: current_user.id,
        entity_type: 'User',
        entity_id: current_user.id,
        target_type: 'User',
        target_id: current_user.id,
        details: { namespace_id: namespace_id, project_ids: project_ids }
      )
    end

    context 'when the user already had different pins in the same namespace' do
      before do
        create(:user_project_pin, user: user, namespace: organization_namespace,
                                  project: create(:namespace_project, namespace: organization_namespace),
                                  priority: 0)
      end

      it 'replaces the old pins entirely' do
        expect { service_response }.to change { user.reload.user_project_pins.count }.to(2)
      end
    end

    context 'when the user has pins in a different namespace' do
      let(:other_namespace) { create(:organization).ensure_namespace }

      before do
        create(:namespace_member, namespace: other_namespace, user: user)
        create(:user_project_pin, user: user, namespace: other_namespace,
                                  project: create(:namespace_project, namespace: other_namespace),
                                  priority: 0)
      end

      it 'does not remove pins from the other namespace' do
        expect { service_response }.not_to(change { UserProjectPin.where(namespace: other_namespace).count })
      end
    end
  end

  context 'when a pin fails to save' do
    let(:current_user) { user }

    before do
      allow(UserProjectPin).to receive(:new).and_wrap_original do |original_method, *args|
        original_method.call(*args).tap do |pin|
          allow(pin).to receive(:save).and_return(false)
        end
      end
    end

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:invalid_user_project_pin) }
    it { expect { service_response }.not_to create_audit_event }

    it 'does not persist any pins' do
      expect { service_response }.not_to(change { UserProjectPin.count })
    end
  end
end
