# frozen_string_literal: true

module Types
  class GenericTypeType < Types::BaseObject
    description 'Represents a generic type that can be used in various contexts.'

    authorize :read_flow

    field :data_type, Types::DataTypeType, null: false, description: 'The data type associated with this generic type.'
    field :generic_mappers, [Types::GenericMapperType], null: false,
                                                        description: 'The mappers associated with this generic type.'

    timestamps
  end
end
