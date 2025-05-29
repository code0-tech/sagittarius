# frozen_string_literal: true

module Types
  module Input
    class GenericMapperInputType < Types::BaseInputObject
      description 'Input type for generic mappers'

      argument :source, Types::Input::DataTypeIdentifierInputType, required: true,
               description: 'The source data type identifier for the mapper'

      argument :target, String, required: true,
                description: 'The target data type identifier for the mapper'
    end
  end
end
