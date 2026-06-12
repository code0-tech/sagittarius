# frozen_string_literal: true

module Types
  class VelorumType < Types::BaseObject
    description 'Represents Velorum integration information'

    field :enabled, Boolean, null: false, description: 'Whether Velorum is enabled'
    field :models, [Types::VelorumModelType], null: false, description: 'Find models available through Velorum'

    def enabled
      config[:enabled]
    end

    def models
      ::Velorum::ModelsService.new(config: config).execute
    end

    private

    def config
      Sagittarius::Configuration.config[:velorum]
    end
  end
end
