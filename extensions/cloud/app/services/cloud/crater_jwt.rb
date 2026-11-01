# frozen_string_literal: true

module CLOUD
  class CraterJwt
    class << self
      def verify(token, secret:, ttl_minutes:)
        claims = Sagittarius::Jwt.decode(token, secret: secret)
        return nil if claims.nil?
        return nil unless valid_claims?(claims, ttl_minutes)

        claims
      end

      private

      def valid_claims?(claims, ttl_minutes)
        now = Time.now.to_i
        exp = claims['exp'].to_i
        iat = claims['iat'].to_i

        return false if exp <= now
        return false if (exp - iat) > ttl_minutes.to_i.minutes.to_i

        true
      end
    end
  end
end
