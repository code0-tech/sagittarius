# frozen_string_literal: true

Rails.application.configure do
  config.zero_track.active_record.timestamps = true
  config.zero_track.active_record.schema_migrations = true
  config.zero_track.active_record.schema_cleaner = true
end
