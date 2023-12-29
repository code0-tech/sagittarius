# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditEvent do
  subject { create(:audit_event, entity: user, action_type: :user_registered, target: user) }

  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('User').inverse_of(:authored_audit_events).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:entity_id) }
    it { is_expected.to validate_presence_of(:entity_type) }
    it { is_expected.to validate_presence_of(:action_type) }
    it { is_expected.to validate_presence_of(:details) }
    it { is_expected.to validate_presence_of(:target_id) }
    it { is_expected.to validate_presence_of(:target_type) }

    it { is_expected.to allow_values(*described_class::ACTION_TYPES.keys).for(:action_type) }
  end
end
