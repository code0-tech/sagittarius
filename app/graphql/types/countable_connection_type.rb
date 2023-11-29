# frozen_string_literal: true

module Types
  class CountableConnectionType < GraphQL::Types::Relay::BaseConnection
    description 'Connection type that provides a count of nodes'

    field :count, GraphQL::Types::Int, null: false, description: 'Total count of collection.'

    def count
      relation = object.items

      # sometimes relation is an Array
      relation = relation.reorder(nil) if relation.respond_to?(:reorder)

      if relation.try(:group_values).present?
        relation.size.keys.size
      else
        relation.size
      end
    end
  end
end
