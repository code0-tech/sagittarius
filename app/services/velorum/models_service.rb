# frozen_string_literal: true

module Velorum
  class ModelsService
    include Code0::ZeroTrack::Loggable

    def initialize(client: nil, config: Sagittarius::Configuration.config[:velorum])
      @client = client
      @config = config
    end

    def execute
      return [] unless config[:enabled]

      client.models.models
    rescue GRPC::BadStatus => e
      logger.warn(
        message: 'Failed to fetch Velorum models',
        grpc_code: e.respond_to?(:code) ? e.code : nil,
        grpc_details: e.respond_to?(:details) ? e.details : e.message
      )
      []
    end

    private

    attr_reader :config

    def client
      @client ||= Sagittarius::Velorum::Client.new
    end
  end
end
