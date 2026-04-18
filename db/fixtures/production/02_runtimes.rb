# frozen_string_literal: true

initial_runtime_token = ENV.fetch('INITIAL_RUNTIME_TOKEN', nil)
return if initial_runtime_token.blank?

return unless Runtime.count.zero?

runtime = Runtime.new(
  name: 'Initial Runtime',
  description: 'Provisioned with token from INITIAL_RUNTIME_TOKEN environment variable',
  token: initial_runtime_token
)

# rubocop:disable Code0/ZeroTrack/Logs/RailsLogger -- we can't include a module here
if runtime.save
  Rails.logger.info(message: 'Initial runtime created')
else
  Rails.logger.warn(message: 'Failed to create initial runtime', errors: runtime.errors.full_messages)
end
# rubocop:enable Code0/ZeroTrack/Logs/RailsLogger
