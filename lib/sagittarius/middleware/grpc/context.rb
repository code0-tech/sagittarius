# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class Context < Grpc::AllMethodServerInterceptor
        def execute(call:, **_, &block)
          correlation_id = call.metadata['correlation_id']
          Sagittarius::Context.with_context(application: 'grpc', external_correlation_id: correlation_id, &block)
        end
      end
    end
  end
end
