# frozen_string_literal: true

module Types
  module DataTypeRules
    class NumberRangeConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      field :from, Integer, null: false,
                            description: 'The minimum value of the range'
      field :steps, Integer, null: true,
                             description: 'The step value for the range, if applicable'
      field :to, Integer, null: false,
                          description: 'The maximum value of the range'
    end
  end
end
