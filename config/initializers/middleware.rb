# frozen_string_literal: true

require_relative '../../lib/sagittarius/context'
require_relative '../../lib/sagittarius/middleware/rack/context'
require_relative '../../lib/sagittarius/middleware/rack/ip_address'

Rails.application.config.middleware.move(1, ActionDispatch::RequestId)
Rails.application.config.middleware.insert(1, Sagittarius::Middleware::Rack::Context)
Rails.application.config.middleware.insert_after(ActionDispatch::RemoteIp, Sagittarius::Middleware::Rack::IpAddress)
