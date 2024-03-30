# frozen_string_literal: true

Rails.application.config.to_prepare do
  next unless Rails.env.production?
  next if ARGV.grep(/db:|orchestrator:/).any?

  ApplicationSetting.assert_settings_present!
end
