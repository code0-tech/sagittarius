# frozen_string_literal: true

User.seed_once :user_type do |u|
  u.username = 'ghost'
  u.email = 'ghost@code0.tech'
  u.password = SecureRandom.hex
  u.admin = false
  u.user_type = :ghost
  u.readme = 'This user will hold the activity of the users that have been deleted'
end
