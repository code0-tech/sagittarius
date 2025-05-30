# frozen_string_literal: true

module Types
  class DataTypeRuleType < Types::BaseObject
    description 'Represents a rule that can be applied to a data type.'

    field :variant, Types::DataTypeRules::DataTypeRuleVariantEnum, null: false,
                                                                   description: 'The type of the rule'

    field :config, Types::DataTypeRules::ConfigType, null: false,
                                                     description: 'The configuration of the rule'

    timestamps

    def config
      object.config.merge(variant: object.variant)
    end
  end
end
