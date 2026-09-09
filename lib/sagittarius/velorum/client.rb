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
        info_stub.models(Tucana::Velorum::ModelsRequest.new, metadata: authentication_metadata)
      end

      def prompt(request)
        generate_stub.prompt(request, metadata: authentication_metadata)
      end

      def flow(request)
        generate_stub.flow(request, metadata: authentication_metadata)
      end

      private

      attr_reader :host, :jwt_secret, :jwt_ttl_minutes

      def info_stub
        @info_stub ||= Tucana::Velorum::InfoService::Stub.new(host, :this_channel_is_insecure)
      end

      def generate_stub
        @generate_stub ||= Tucana::Velorum::GenerateService::Stub.new(host, :this_channel_is_insecure)
      end

      def authentication_metadata
        {
          authorization: jwt,
        }
      end

      def jwt
        raise ArgumentError, 'velorum.jwt_secret must be configured' if jwt_secret.to_s.empty?

        now = Time.now.to_i
        claims = {
          iat: now - 60,
          exp: now + jwt_ttl_minutes.to_i.minutes.to_i,
        }

        Sagittarius::Jwt.encode(claims, secret: jwt_secret)
      end
    end
  end
end
