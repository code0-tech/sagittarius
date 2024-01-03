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
    it { is_expected.to validate_presence_of(:value) }

    it { is_expected.to validate_uniqueness_of(:setting).ignoring_case_sensitivity }
    it { is_expected.to allow_values(*described_class::SETTINGS.keys).for(:setting) }
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
