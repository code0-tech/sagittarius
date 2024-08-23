# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class AllMethodServerInterceptor < ::GRPC::ServerInterceptor
        def request_response(request: nil, call: nil, method: nil, &block)
          execute(request: request, call: call, method: method, &block)
        end

        def server_streamer(request: nil, call: nil, method: nil, &block)
          execute(request: request, call: call, method: method, &block)
        end

        def client_streamer(call: nil, method: nil, &block)
          execute(request: nil, call: call, method: method, &block)
        end

        def bidi_streamer(request: nil, call: nil, method: nil, &block)
          execute(request: request, call: call, method: method, &block)
        end

        def execute(request:, call:, method:)
          raise NotImplementedError
        end
      end
    end
  end
end
