# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Root Query type'

    field :node, Types::NodeType, null: true, description: 'Fetches an object given its ID.' do
      argument :id, ID, required: true, description: 'ID of the object.'
    end

    field :nodes, [Types::NodeType, { null: true }], null: true,
                                                     description: 'Fetches a list of objects given a list of IDs.' do
      argument :ids, [ID], required: true, description: 'IDs of the objects.'
    end

    field :echo, GraphQL::Types::String, null: false, description: 'Field available for use to test API access' do
      argument :message, GraphQL::Types::String, required: true, description: 'String to echo as response'
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    def echo(message:)
      message
    end
  end
end
