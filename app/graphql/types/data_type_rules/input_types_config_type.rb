# frozen_string_literal: true

module Types
  module DataTypeRules
    class InputTypesConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      authorize :read_flow
    end
  end
end
