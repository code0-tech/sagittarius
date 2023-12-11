# frozen_string_literal: true

require_relative '../../lib/sagittarius/context'
require_relative '../../lib/sagittarius/middleware/rack'

Rails.application.config.middleware.move(1, ActionDispatch::RequestId)
Rails.application.config.middleware.insert(1, Sagittarius::Middleware::Rack)
