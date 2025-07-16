# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class Authentication < Grpc::AllMethodServerInterceptor
        ANONYMOUS_SERVICES = %w[grpc.health.v1.Health].freeze

        def execute(call:, method:, **_)
          authorization_token = call.metadata['authorization']
          runtime = Runtime.find_by(token: authorization_token) if authorization_token.present?

          if runtime.present?
            Code0::ZeroTrack::Context.push(runtime: { id: runtime.id, namespace_id: runtime.namespace&.id })
          elsif ANONYMOUS_SERVICES.exclude?(method.owner.service_name) || authorization_token.present?
            raise GRPC::Unauthenticated, 'No valid runtime token provided' if runtime.nil?
          end

          yield
        end
      end
    end
  end
end
