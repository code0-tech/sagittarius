# frozen_string_literal: true

module Types
  module DataTypeRules
    class RegexConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      authorize :read_datatype

      field :pattern, String, null: false,
                              description: 'The regex pattern to match against the data type value.'
    end
  end
end
