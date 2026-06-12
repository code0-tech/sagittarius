# frozen_string_literal: true

module Velorum
  class ModelsService
    def initialize(client: nil, config: Sagittarius::Configuration.config[:velorum])
      @client = client
      @config = config
    end

    def execute
      unless config[:enabled]
        raise GraphQL::ExecutionError.new(
          'Velorum is disabled',
          extensions: { code: 'VELORUM_DISABLED' }
        )
      end

      client.models.models
    end

    private

    attr_reader :config

    def client
      @client ||= Sagittarius::Velorum::Client.new
    end
  end
end
