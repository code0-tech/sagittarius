# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationSetting do
  around with_clean_settings: true do |example|
    described_class.delete_all
    example.run

    SeedFu.seed(SeedFu.fixture_paths, /01_application_settings/)
  end

  around recreating_settings: true do |example|
    example.run

    described_class.delete_all
    SeedFu.seed(SeedFu.fixture_paths, /01_application_settings/)
  end

  describe 'validations', :with_clean_settings do
    subject { create(:application_setting, setting: :user_registration_enabled, value: true) }

    it { is_expected.to validate_presence_of(:setting) }

    context 'when not a url option' do
      subject { build(:application_setting, setting: :user_registration_enabled, value: nil) }

      it { is_expected.not_to be_valid }
    end

    it { is_expected.to validate_uniqueness_of(:setting).ignoring_case_sensitivity }
    it { is_expected.to allow_values(*described_class::SETTINGS.keys).for(:setting) }

    context 'when validating url options' do
      described_class::URL_OPTIONS.each do |option|
        context "with #{option}" do
          context 'with a long valid url' do
            subject { create(:application_setting, setting: option, value: "http://#{'a' * 2030}.com") }

            it { is_expected.to be_valid }
          end

          context 'when the value is too long' do
            subject { build(:application_setting, setting: option, value: "http://#{'a' * 2049}.com") }

            it { is_expected.not_to be_valid }
          end

          context 'with invalid url' do
            subject(:setting) { build(:application_setting, setting: option, value: 'invalid-url') }

            it 'is invalid' do
              expect(setting).not_to be_valid
            end
          end

          context 'with valid url' do
            subject { create(:application_setting, setting: option, value: 'https://example.com') }

            it { is_expected.to be_valid }
          end

          context 'with nil value' do
            subject { create(:application_setting, setting: option, value: nil) }

            it { is_expected.to be_valid }
          end
        end
      end
    end
  end

  context 'when validating default settings' do
    described_class.find_each do |setting|
      it "#{setting.setting} is valid" do
        expect(setting).to be_valid
      end
    end
  end

  describe '.current' do
    it { expect(described_class.current.keys).to eq(described_class::SETTINGS.keys) }

    it 'raises if settings are missing', :recreating_settings do
      described_class.first.delete

      expect { described_class.current }.to raise_error('Missing application settings: ["user_registration_enabled"]')
    end
  end
end
