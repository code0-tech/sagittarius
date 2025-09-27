# frozen_string_literal: true

module Types
  class BaseUnion < GraphQL::Schema::Union
    include Sagittarius::Graphql::HasMarkdownDocumentation

    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::CountableConnectionType)

    def self.inherited(subclass)
      super
      subclass.graphql_name subclass.name.delete_prefix('Types::').gsub('::', '').delete_suffix('Type')
    end
  end
end
