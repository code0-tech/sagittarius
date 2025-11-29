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
    subject(:setting) { create(:application_setting, setting: :user_registration_enabled, value: true) }

    it { is_expected.to validate_presence_of(:setting) }
    it { is_expected.to validate_presence_of(:value) }

    it { is_expected.to validate_uniqueness_of(:setting).ignoring_case_sensitivity }
    it { is_expected.to allow_values(*described_class::BOOLEAN_OPTIONS).for(:setting) }

    it 'allows identity providers' do
      setting.value = []
      is_expected.to allow_value(:identity_providers).for(:setting)
    end

    context 'when validating identity providers' do
      it 'is invalid with missing id' do
        setting = described_class.new(setting: :identity_providers, value: [{ type: 'saml', config: {} }])
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:value, :id_type_or_config_missing)).to be true
      end

      it 'is invalid with missing type' do
        setting = described_class.new(setting: :identity_providers, value: [{ id: 'provider1', config: {} }])
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:value, :id_type_or_config_missing)).to be true
      end

      it 'is invalid with missing config' do
        setting = described_class.new(setting: :identity_providers, value: [{ id: 'provider1', type: 'saml' }])
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:value, :id_type_or_config_missing)).to be true
      end

      it 'is valid with complete provider configuration' do
        setting = described_class.new(setting: :identity_providers, value: [
                                        {
                                          id: 'provider1',
                                          type: 'saml',
                                          config: {},
                                        }
                                      ])
        expect(setting).to be_valid
      end

      it 'is invalid with extra keys in saml config' do
        setting = described_class.new(setting: :identity_providers, value: [
                                        {
                                          id: 'provider1',
                                          type: 'saml',
                                          config: { invalid_key: 'value' },
                                        }
                                      ])
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:value, :invalid_saml_configuration_keys)).to be true
      end

      it 'is invalid with missing keys in oidc config' do
        setting = described_class.new(setting: :identity_providers, value: [
                                        {
                                          id: 'provider1',
                                          type: 'oidc',
                                          config: { client_id: 'id' },
                                        }
                                      ])
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:value, :missing_oidc_configuration_keys)).to be true
      end

      it 'expects valid OIDC configuration' do
        setting = described_class.new(setting: :identity_providers, value: [
                                        {
                                          id: 'provider1',
                                          type: 'oidc',
                                          config: {
                                            client_id: 'id',
                                            client_secret: 'secret',
                                            redirect_uri: 'https://example.com/callback',
                                            user_details_url: 'https://example.com/userinfo',
                                            authorization_url: 'https://example.com/auth',
                                          },
                                        }
                                      ])
        expect(setting).to be_valid
      end

      it "doesn't expect user_details for discord" do
        setting = described_class.new(setting: :identity_providers, value: [
                                        {
                                          id: 'discord',
                                          type: 'discord',
                                          config: {
                                            client_id: 'id',
                                            client_secret: 'secret',
                                            redirect_uri: 'https://example.com/callback',
                                          },
                                        }
                                      ])
        expect(setting).to be_valid
      end

      it 'does expect user_details_url for oidc' do
        setting = described_class.new(setting: :identity_providers, value: [
                                        {
                                          id: 'oidc',
                                          type: 'oidc',
                                          config: {
                                            client_id: 'id',
                                            client_secret: 'secret',
                                            redirect_uri: 'https://example.com/callback',
                                            authorization_url: 'https://example.com/auth',
                                          },
                                        }
                                      ])
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:value, :missing_oidc_configuration_keys)).to be true
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
