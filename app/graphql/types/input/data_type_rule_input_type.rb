# frozen_string_literal: true

module Types
  module Input
    class DataTypeRuleInputType < Types::BaseInputObject
      description 'Input for creation of a new DataTypeRule'

      argument :variant, Types::DataTypeRules::VariantEnum,
               required: true,
               description: 'The type of the rule'

      argument :config, Types::Input::DataTypeRuleConfigInputType,
               required: true,
               description: 'The config of the rule'
    end
  end
end
