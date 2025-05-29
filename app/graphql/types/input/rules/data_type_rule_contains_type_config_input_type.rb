# frozen_string_literal: true

module Types
  module Input
    module Rules
      class DataTypeRuleContainsTypeConfigInputType < Types::BaseInputObject
        description 'Input type for Data Type Rule Contains Type configuration'

        argument :data_type_identifier, Types::Input::DataTypeIdentifierInputType,
                 required: false, description: 'The identifier of the data type this rule applies to'
      end
    end
  end
end
