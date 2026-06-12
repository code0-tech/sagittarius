# frozen_string_literal: true

module Velorum
  class ModelsService
    def initialize(client: nil, config: Sagittarius::Configuration.config[:velorum])
      @client = client
      @config = config
    end

    def execute
      return [] unless config[:enabled]

      client.models.models
    end

    private

    attr_reader :config

    def client
      @client ||= Sagittarius::Velorum::Client.new
    end
  end
end
