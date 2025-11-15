# frozen_string_literal: true

module Types
  class MetadataType < Types::BaseObject
    graphql_name 'Metadata'
    description 'Application metadata'

    field :version, GraphQL::Types::String, null: false, description: 'Application version'
    field :extensions, [GraphQL::Types::String], null: false, description: 'List of loaded extensions'
  end
end
