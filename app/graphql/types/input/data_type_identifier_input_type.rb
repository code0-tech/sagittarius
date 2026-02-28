# frozen_string_literal: true

module Types
  module Input
    class DataTypeIdentifierInputType < Types::BaseInputObject
      description 'Input for creation of a new DataTypeIdentifier'

      argument :data_type, Types::Input::DataTypeInputType,
               required: false,
               description: 'Data type'
      argument :generic_key, String,
               required: false,
               description: 'Generic key value'
      argument :generic_type, Types::Input::GenericTypeInputType,
               required: false,
               description: 'Generic type information'
    end
  end
end
