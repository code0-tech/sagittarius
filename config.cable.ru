# frozen_string_literal: true

require_relative 'config/environment'
Rails.application.eager_load!

map '/health/liveness' do
  run lambda { |_env|
    begin
      ApplicationRecord.connection.execute('SELECT 1')
      [200, { 'content-type' => 'text/plain' }, ['OK']]
    rescue StandardError => e
      if Rails.env.local?
        [500, { 'content-type' => 'text/plain' }, [e.message]]
      else
        [500, { 'content-type' => 'text/plain' }, ['ERROR']]
      end
    end
  }
end

run ActionCable.server
