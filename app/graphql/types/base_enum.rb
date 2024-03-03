# frozen_string_literal: true

module Types
  class BaseEnum < GraphQL::Schema::Enum
    include Sagittarius::Graphql::HasMarkdownDocumentation

    def self.inherited(subclass)
      super
      subclass.graphql_name subclass.name.delete_prefix('Types::').delete_suffix('Enum').gsub('::', '')
    end
  end
end
