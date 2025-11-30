# frozen_string_literal: true

class ApplicationSetting < ApplicationRecord
  include Code0::ZeroTrack::Loggable

  # Custom class used for policy association
  ApplicationSettings = Class.new(ActiveSupport::HashWithIndifferentAccess)
  MissingApplicationSettings = Class.new(StandardError)

  SETTINGS = {
    user_registration_enabled: 1,
    organization_creation_restricted: 2,
    identity_providers: 3,
    admin_status_visible: 4,
  }.with_indifferent_access

  BOOLEAN_OPTIONS = %i[user_registration_enabled organization_creation_restricted admin_status_visible].freeze

  enum :setting, SETTINGS

  validates :setting, presence: true,
                      uniqueness: true,
                      inclusion: {
                        in: SETTINGS.keys.map(&:to_s),
                      }
  validate :validate_value

  validate :validate_identity_providers, if: :identity_providers?

  BOOLEAN_OPTIONS.each do |option|
    validates :value, inclusion: { in: [false, true] }, if: :"#{option}?"
  end

  def validate_value
    errors.add(:value, :blank) if value.nil?
  end

  def validate_identity_providers
    value.each do |provider|
      provider.deep_symbolize_keys!
      if provider[:id].nil? || provider[:type].nil? || provider[:config].nil?
        next errors.add(:value, :id_type_or_config_missing)
      end

      if provider[:type] == 'saml'
        allowed_keys = %i[provider_name attribute_statements settings response_settings metadata_url]
        errors.add(:value, :invalid_saml_configuration_keys) unless (provider[:config].keys - allowed_keys).empty?
      else
        required_keys = %i[client_id client_secret redirect_uri user_details_url authorization_url]
        allowed_keys = %i[provider_name attribute_statements] + required_keys

        required_keys -= %i[user_details_url authorization_url] unless provider[:type] == 'oidc'

        errors.add(:value, :invalid_oidc_configuration_keys) unless (provider[:config].keys - allowed_keys).empty?
        errors.add(:value, :missing_oidc_configuration_keys) unless (required_keys - provider[:config].keys).empty?
      end
    end
  end

  def self.assert_settings_present!(records = ApplicationSetting.all)
    missing_settings = SETTINGS.keys - records.map(&:setting)
    return if missing_settings.empty?

    logger.error 'Some application settings are missing. Create them with the seed.'
    logger.error 'bundle exec rake db:seed_fu FILTER=01_application_settings'
    raise MissingApplicationSettings,
          "Missing application settings: #{missing_settings.inspect}"
  end

  def self.current
    records = ApplicationSetting.all
    assert_settings_present!(records)

    overrides = Sagittarius::Configuration.application_setting_overrides

    records.each_with_object(ApplicationSettings.new) do |record, acc|
      acc[record.setting] = overrides.fetch(record.setting.to_sym, record.value)
    end
  end
end
