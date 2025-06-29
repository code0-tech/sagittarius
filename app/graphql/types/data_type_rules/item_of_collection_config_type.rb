# frozen_string_literal: true

module Types
  module DataTypeRules
    class ItemOfCollectionConfigType < Types::BaseObject
      description 'Represents a rule that can be applied to a data type.'

      authorize :read_flow

      field :items, [GraphQL::Types::JSON], null: true,
                                            description: 'The items that can be configured for this rule.'
    end
  end
end
