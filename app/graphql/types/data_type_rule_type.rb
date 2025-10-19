# frozen_string_literal: true

module Types
  class DataTypeRuleType < Types::BaseObject
    description 'Represents a rule that can be applied to a data type.'

    authorize :read_datatype

    field :variant, Types::DataTypeRules::VariantEnum, null: false, description: 'The type of the rule'

    field :config, Types::DataTypeRules::ConfigType, null: false,
                                                     description: 'The configuration of the rule'

    id_field ::DataTypeRule
    timestamps

    def variant
      object.variant.to_sym
    end

    def config
      if object.variant_parent_type?
        object
      else
        object.config.merge(variant: object.variant)
      end
    end
  end
end
