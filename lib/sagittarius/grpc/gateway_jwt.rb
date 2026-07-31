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
          payload = {
            sub: runtime_id.to_s,
            exp: Time.now.to_i + ttl_seconds.to_i,
          }

          "#{BEARER_SCHEME}#{sign(payload, secret)}"
        end

        def decode(token, secret:)
          return nil if token.blank?

          header, payload, signature = token.to_s.split('.')
          return nil if header.nil? || payload.nil? || signature.nil?
          return nil unless valid_signature?(header, payload, signature, secret)

          claims = JSON.parse(base64_url_decode(payload))
          return nil if claims['exp'].to_i < Time.now.to_i

          Integer(claims['sub'])
        rescue JSON::ParserError, ArgumentError, TypeError
          nil
        end

        private

        def sign(payload, secret)
          header = { alg: 'HS256', typ: 'JWT' }
          body = [header, payload].map { |part| base64_url_encode(part.to_json) }.join('.')

          "#{body}.#{base64_url_encode(OpenSSL::HMAC.digest('SHA256', secret.to_s, body))}"
        end

        def valid_signature?(header, payload, signature, secret)
          body = "#{header}.#{payload}"
          expected_signature = base64_url_encode(OpenSSL::HMAC.digest('SHA256', secret.to_s, body))

          ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
        end

        def base64_url_encode(value)
          Base64.urlsafe_encode64(value, padding: false)
        end

        def base64_url_decode(value)
          Base64.urlsafe_decode64(value)
        end
      end
    end
  end
end
