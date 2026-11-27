# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sagittarius::Validators::PasswordValidator do
  subject(:record) { model_class.new(password) }

  let(:model_class) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :password

      validates :password, 'sagittarius/validators/password': true, allow_blank: true

      def initialize(password)
        @password = password
      end
    end
  end

  def error_types
    record.tap(&:valid?).errors.map(&:type)
  end

  context 'when the password satisfies the policy' do
    let(:password) { 'Password123!' }

    it { is_expected.to be_valid }
  end

  context 'when the password is blank' do
    let(:password) { '' }

    it 'is skipped by allow_blank' do
      expect(record).to be_valid
    end
  end

  context 'when the password is too short' do
    let(:password) { 'Ab1!' }

    it { expect(error_types).to include(:too_short) }
  end

  context 'when the password has no uppercase letter' do
    let(:password) { 'password123!' }

    it { expect(error_types).to include(:no_uppercase) }
  end

  context 'when the password has no lowercase letter' do
    let(:password) { 'PASSWORD123!' }

    it { expect(error_types).to include(:no_lowercase) }
  end

  context 'when the password has no number' do
    let(:password) { 'Password!!!' }

    it { expect(error_types).to include(:no_number) }
  end

  context 'when the password has no special character' do
    let(:password) { 'Password1234' }

    it { expect(error_types).to include(:no_special_character) }
  end
end
