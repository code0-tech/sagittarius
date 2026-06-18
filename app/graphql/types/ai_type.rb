# frozen_string_literal: true

module Types
  class AiType < Types::BaseObject
    description 'Represents AI integration information'

    authorize :read_velorum_config
    declarative_policy_subject { :global }

    field :enabled, Boolean, null: false, description: 'Whether AI is enabled'
    field :models, [Types::AiModelType], null: false, description: 'Find models available through AI'

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
