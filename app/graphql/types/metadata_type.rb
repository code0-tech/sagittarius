# frozen_string_literal: true

module Types
  class MetadataType < Types::BaseObject
    description 'Application metadata'

    field :extensions, [GraphQL::Types::String], null: false, description: 'List of loaded extensions'
    field :version, GraphQL::Types::String, null: false, description: 'Application version'
  end
end
