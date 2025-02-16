# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Rack
      class IpAddress
        def initialize(app)
          @app = app
        end

        def call(env)
          Code0::ZeroTrack::Context.with_context(ip_address: ip_address(env)) do
            @app.call env
          end
        end

        def ip_address(env)
          ::Rack::Request.new(env).ip
        end
      end
    end
  end
end
