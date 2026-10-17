# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.deliver_later_queue_name = 'mailer'

  config.action_mailer.smtp_settings = Sagittarius::Configuration.config.dig(:rails, :mailer, :smtp_settings)

  config.action_mailer.delivery_method = :smtp
end
