# frozen_string_literal: true

module Sagittarius
  class Jwt
    class << self
      def encode(claims, secret:)
        header = { alg: 'HS256', typ: 'JWT' }
        body = [header, claims].map { |part| base64_url_encode(part.to_json) }.join('.')

        "#{body}.#{base64_url_encode(OpenSSL::HMAC.digest('SHA256', secret.to_s, body))}"
      end

      def decode(token, secret:)
        return nil if token.blank?

        header, payload, signature = token.to_s.split('.')
        return nil if header.nil? || payload.nil? || signature.nil?
        return nil unless valid_signature?(header, payload, signature, secret)

        JSON.parse(base64_url_decode(payload))
      rescue JSON::ParserError, ArgumentError, TypeError
        nil
      end

      private

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
