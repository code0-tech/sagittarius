# frozen_string_literal: true

module Sagittarius
  module Velorum
    class Client
      def initialize(host: Sagittarius::Configuration.config[:velorum][:grpc][:host])
        @host = host
      end

      def models
        stub.models(Tucana::Velorum::ModelsRequest.new)
      end

      private

      attr_reader :host

      def stub
        @stub ||= Tucana::Velorum::InfoService::Stub.new(host, :this_channel_is_insecure)
      end
    end
  end
end
