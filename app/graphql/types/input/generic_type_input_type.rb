# frozen_string_literal: true

module Types
  module Input
    class GenericTypeInputType < Types::BaseInputObject
      description 'Input type for generic type operations.'

      argument :data_type_id, Types::GlobalIdType[::DataType], required: true, description: 'The data type associated with this generic type.'
      argument :generic_mappers, [Types::Input::GenericMapperInputType], required: true,
            description: 'The mappers associated with this generic type.'


    end
  end
end
