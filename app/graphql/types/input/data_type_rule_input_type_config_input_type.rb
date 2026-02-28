# frozen_string_literal: true

module Types
  module Input
    class DataTypeRuleInputTypeConfigInputType < Types::BaseInputObject
      description 'Input type for the config of a data type rule'

      argument :data_type_identifier, Types::Input::DataTypeIdentifierInputType,
               required: true,
               description: 'Data type identifier'

      argument :input_identifier, String,
               required: true,
               description: 'The input identifier that this configuration applies to'
    end
  end
end
