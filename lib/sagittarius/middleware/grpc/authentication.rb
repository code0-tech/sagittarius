# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class Authentication < Grpc::AllMethodServerInterceptor
        def execute(call:, **_)
          authorization_token = call.metadata['authorization']
          runtime = Runtime.find_by(token: authorization_token)

          raise GRPC::Unauthenticated, 'No valid runtime token provided' if runtime.nil?

          Code0::ZeroTrack::Context.push(runtime: { id: runtime.id, namespace_id: runtime.namespace&.id })

          yield
        end
      end
    end
  end
end
