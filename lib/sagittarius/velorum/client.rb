# frozen_string_literal: true

module Sagittarius
  module Velorum
    class Client
      def initialize(
        host: Sagittarius::Configuration.config[:velorum][:host],
        jwt_secret: Sagittarius::Configuration.config[:velorum][:jwt_secret],
        jwt_ttl_minutes: Sagittarius::Configuration.config[:velorum][:jwt_ttl_minutes]
      )
        @host = host
        @jwt_secret = jwt_secret
        @jwt_ttl_minutes = jwt_ttl_minutes
      end

      def models
        stub.models(Tucana::Velorum::ModelsRequest.new, metadata: authentication_metadata)
      end

      private

      attr_reader :host, :jwt_secret, :jwt_ttl_minutes

      def stub
        @stub ||= Tucana::Velorum::InfoService::Stub.new(host, :this_channel_is_insecure)
      end

      def authentication_metadata
        {
          authorization: jwt,
        }
      end

      def jwt
        raise ArgumentError, 'velorum.jwt_secret must be configured' if jwt_secret.to_s.empty?

        header = {
          alg: 'HS256',
          typ: 'JWT',
        }
        now = Time.now.to_i
        payload = {
          iat: now - 60,
          exp: now + jwt_ttl_minutes.to_i.minutes.to_i,
        }
        body = [header, payload].map { |part| base64_url_encode(part.to_json) }.join('.')
        signature = OpenSSL::HMAC.digest('SHA256', jwt_secret, body)

        "#{body}.#{base64_url_encode(signature)}"
      end

      def base64_url_encode(value)
        Base64.urlsafe_encode64(value, padding: false)
      end
    end
  end
end
