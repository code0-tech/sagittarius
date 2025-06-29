# frozen_string_literal: true

module Types
  module Input
    class DataTypeIdentifierInputType < Types::BaseInputObject
      description 'Input type for data type identifier'

      argument :data_type_id, Types::GlobalIdType[::DataType], required: false,
                                                               description: 'Data type ID'
      argument :generic_key, String, required: false,
                                     description: 'Generic key value'
      argument :generic_type, Types::Input::GenericTypeInputType, required: false,
                                                                  description: 'Generic type information'
    end
  end
end
