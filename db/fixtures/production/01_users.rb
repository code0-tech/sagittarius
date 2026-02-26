# frozen_string_literal: true

return unless User.count.zero?

initial_root_email = ENV.fetch('INITIAL_ROOT_MAIL', nil)
initial_root_password = ENV.fetch('INITIAL_ROOT_PASSWORD', SecureRandom.hex)

root = User.new(
  username: 'root',
  email: initial_root_email,
  email_verified_at: Time.zone.now,
  password: initial_root_password,
  admin: true
)

# rubocop:disable ZeroTrack/Logs/RailsLogger -- we can't include a module here
if root.save
  Rails.logger.info(message: 'Initial root user created', email: initial_root_email, password: initial_root_password)
else
  Rails.logger.warn(message: 'Failed to create initial root user', errors: root.errors.full_messages)
end
# rubocop:enable ZeroTrack/Logs/RailsLogger
