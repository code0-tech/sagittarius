# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject { create(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:user_sessions).inverse_of(:user) }
    it { is_expected.to have_many(:authored_audit_events).class_name('AuditEvent').inverse_of(:author) }
    it { is_expected.to have_many(:namespace_memberships).class_name('NamespaceMember').inverse_of(:user) }
    it { is_expected.to have_many(:namespaces).through(:namespace_memberships).inverse_of(:users) }
    it { is_expected.to have_many(:user_custom_attributes).inverse_of(:user) }
    it { is_expected.to have_many(:user_namespace_pins).inverse_of(:user) }
    it { is_expected.to have_many(:user_project_pins).inverse_of(:user) }
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

    describe 'password policy' do
      subject(:user) { build(:user, password: password, enforce_password_policy: true) }

      context 'when the password is compliant' do
        let(:password) { 'Password123!' }

        it { is_expected.to be_valid }
      end

      context 'when the password is weak' do
        let(:password) { 'weak' }

        it 'is invalid and reports the policy violations on the password' do
          expect(user).not_to be_valid
          expect(user.errors.where(:password).map(&:type))
            .to include(:too_short, :no_uppercase, :no_number, :no_special_character)
        end
      end

      context 'when the policy is not enforced' do
        subject(:user) { build(:user, password: 'weak', enforce_password_policy: false) }

        it { is_expected.to be_valid }
      end
    end
  end

  describe '#deletion_restriction' do
    subject(:user) { create(:user) }

    context 'when user is the last administrator' do
      before { user.update!(admin: true) }

      it 'returns :last_administrator' do
        expect(user.deletion_restriction).to eq(:last_administrator)
      end
    end

    context 'when another administrator exists' do
      before do
        user.update!(admin: true)
        create(:user, :admin)
      end

      it 'returns nil' do
        expect(user.deletion_restriction).to be_nil
      end
    end

    context 'when user is not an administrator' do
      before { create(:user, :admin) }

      it 'returns nil' do
        expect(user.deletion_restriction).to be_nil
      end
    end
  end

  describe 'scopes for operational mail recipients' do
    it 'administrators finds only instance administrators' do
      administrator = create(:user, admin: true)
      create(:user)

      expect(described_class.administrators).to contain_exactly(administrator)
    end

    it 'notifiable leaves out blocked accounts and the non-human user types' do
      regular = create(:user)
      create(:user, blocked_at: Time.current)
      create(:user, :guest)

      expect(described_class.notifiable).to contain_exactly(regular)
    end
  end
end
