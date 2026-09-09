# frozen_string_literal: true

module Sagittarius
  module Grpc
    # Signs and verifies the HS256 JWTs exchanged with the Rust gateway.
    #
    # Rails signs a token (sub: runtime_id) on every call it makes to the gateway's Push RPCs,
    # and verifies the token the gateway sends on every call it makes into Rails. Both sides
    # must be configured with the same secret (rails.gateway.jwt_secret <-> gateway auth.jwt_secret).
    class GatewayJwt
      BEARER_SCHEME = 'Bearer '

      class << self
        def encode(runtime_id, secret:, ttl_seconds:)
          claims = {
            sub: runtime_id.to_s,
            exp: Time.now.to_i + ttl_seconds.to_i,
          }

          "#{BEARER_SCHEME}#{Sagittarius::Jwt.encode(claims, secret: secret)}"
        end

        def decode(token, secret:)
          claims = Sagittarius::Jwt.decode(token, secret: secret)
          return nil if claims.nil?
          return nil if claims['exp'].to_i < Time.now.to_i

          Integer(claims['sub'])
        rescue ArgumentError, TypeError
          nil
        end
      end
    end
  end
end
