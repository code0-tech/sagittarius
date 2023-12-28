# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Rack
      class Context
        def initialize(app)
          @app = app
        end

        def call(env)
          Sagittarius::Context.with_context(
            Sagittarius::Context::CORRELATION_ID_KEY => correlation_id(env),
            application: 'puma'
          ) do |context|
            status, headers, response = @app.call env
            headers['X-Sagittarius-Meta'] = context_to_json context
            [status, headers, response]
          end
        end

        def correlation_id(env)
          ActionDispatch::Request.new(env).request_id
        end

        def context_to_json(context)
          context
            .to_h
            .transform_keys { |k| k.delete_prefix("#{Sagittarius::Context::LOG_KEY}.") }
            .to_json
        end
      end
    end
  end
end
