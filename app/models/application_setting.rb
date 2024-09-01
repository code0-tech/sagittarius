# frozen_string_literal: true

class ApplicationSetting < ApplicationRecord
  include Sagittarius::Loggable

  # Custom class used for policy association
  ApplicationSettings = Class.new(ActiveSupport::HashWithIndifferentAccess)
  MissingApplicationSettings = Class.new(StandardError)

  SETTINGS = {
    user_registration_enabled: 1,
    organization_creation_restricted: 2,
  }.with_indifferent_access

  BOOLEAN_OPTIONS = %i[user_registration_enabled organization_creation_restricted].freeze

  enum :setting, SETTINGS

  validates :setting, presence: true,
                      uniqueness: true,
                      inclusion: {
                        in: SETTINGS.keys.map(&:to_s),
                      }
  validate :validate_value

  BOOLEAN_OPTIONS.each do |option|
    validates :value, inclusion: { in: [false, true] }, if: :"#{option}?"
  end

  def validate_value
    errors.add(:value, :blank) if value.nil?
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
