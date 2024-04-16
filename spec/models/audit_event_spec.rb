# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuditEvent do
  subject { create(:audit_event, entity: user, action_type: :user_registered, target: user) }

  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:author).class_name('User').inverse_of(:authored_audit_events).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:entity_id) }
    it { is_expected.to validate_presence_of(:entity_type) }
    it { is_expected.to validate_presence_of(:action_type) }
    it { is_expected.to validate_presence_of(:details) }
    it { is_expected.to validate_presence_of(:target_id) }
    it { is_expected.to validate_presence_of(:target_type) }

    it { is_expected.to allow_values(*described_class::ACTION_TYPES.keys).for(:action_type) }

    describe 'author validation' do
      context 'when creating new record' do
        subject do
          described_class.new(
            entity_id: 1,
            entity_type: 'Something',
            action_type: 1,
            details: {},
            target_id: 1,
            target_type: 'Something'
          )
        end

        it { is_expected.to validate_presence_of(:author_id) }
      end

      it { is_expected.not_to validate_presence_of(:author_id) }
    end
  end
end
