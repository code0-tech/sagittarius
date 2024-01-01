# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:user_sessions).inverse_of(:user) }
    it { is_expected.to have_many(:authored_audit_events).class_name('AuditEvent').inverse_of(:author) }
    it { is_expected.to have_many(:team_memberships).class_name('TeamMember').inverse_of(:user) }
    it { is_expected.to have_many(:teams).through(:team_memberships).inverse_of(:users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_most(50) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }

    it { is_expected.to validate_length_of(:firstname).is_at_most(50) }
    it { is_expected.to validate_length_of(:lastname).is_at_most(50) }
  end
end
