# frozen_string_literal: true

module Types
  class GenericCombinationStrategyType < Types::BaseObject
    description 'Represents a combination strategy with AND/OR logic used by a generic mapper.'

    field :type, Types::GenericCombinationStrategyTypeEnum, null: false,
                                                            description: "The combination type ('AND' or 'OR')."

    field :generic_mapper, Types::GenericMapperType, null: true,
                                                     description: 'The associated generic mapper, if any.'

    id_field GenericCombinationStrategy
    timestamps
  end
end
