# frozen_string_literal: true

module Velorum
  class ModelsService
    def initialize(client: Sagittarius::Velorum::Client.new)
      @client = client
    end

    def execute
      client.models.models
    end

    private

    attr_reader :client
  end
end
