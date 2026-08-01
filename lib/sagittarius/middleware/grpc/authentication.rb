# frozen_string_literal: true

module Sagittarius
  module Middleware
    module Grpc
      class Authentication < Grpc::AllMethodServerInterceptor
        # These services authenticate themselves (or don't need to): the health check is
        # unauthenticated by design, and TokenService.Verify is how the gateway resolves a raw
        # Aquila token to a runtime_id in the first place, so it can't require a runtime JWT.
        ANONYMOUS_SERVICES = %w[grpc.health.v1.Health sagittarius_rails.TokenService].freeze
        BEARER_SCHEME = 'Bearer '

        def execute(call:, method:, **_)
          return yield if ANONYMOUS_SERVICES.include?(method.owner.service_name)

          runtime = runtime_from(call.metadata['authorization'])
          raise GRPC::Unauthenticated, 'No valid runtime token provided' if runtime.nil?

          Code0::ZeroTrack::Context.push(runtime: { id: runtime.id, namespace_id: runtime.namespace&.id })

          yield
        end

        private

        def runtime_from(authorization_header)
          return nil if authorization_header.blank?

          token = authorization_header.delete_prefix(BEARER_SCHEME)
          runtime_id = Sagittarius::Grpc::GatewayJwt.decode(
            token,
            secret: Sagittarius::Configuration.config[:rails][:gateway][:jwt_secret]
          )
          return nil if runtime_id.nil?

          Runtime.find_by(id: runtime_id)
        end
      end
    end
  end
end
