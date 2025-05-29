# frozen_string_literal: true

module Types
  module Input
    module Rules
      class DataTypeRuleInputType < Types::BaseInputObject
        description 'Input type for Data Type Rule'

        argument :contains_key, DataTypeRuleContainsKeyConfigInputType,
                 required: false, description: 'Configuration for contains key rule'

        argument :contains_value, DataTypeRuleContainsTypeConfigInputType,
                 required: false, description: 'Configuration for contains type rule'
      end
    end
  end
end
