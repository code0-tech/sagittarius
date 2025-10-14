# frozen_string_literal: true

module Types
  class GenericCombinationStrategyTypeEnum < Types::BaseEnum
    description 'The available combination strategy types.'

    value 'AND', value: 'and', description: 'Represents a logical AND combination.'
    value 'OR',  value: 'or',  description: 'Represents a logical OR combination.'
  end
end
