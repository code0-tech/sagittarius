# frozen_string_literal: true

module Types
  module Input
    module Rules
      class DataTypeRuleContainsKeyConfigInputType < Types::BaseInputObject
        description 'Input type for Data Type Rule Contains A Key configuration'

        argument :key, String, required: true, description: 'The key to check for in the data type rule'
        argument :data_type_identifier, Types::Input::DataTypeIdentifierInputType, required: false,
                 description: 'The identifier of the data type this rule applies to'

      end
    end
  end
end
