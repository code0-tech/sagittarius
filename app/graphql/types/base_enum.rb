# frozen_string_literal: true

module Types
  class BaseEnum < GraphQL::Schema::Enum
    include Sagittarius::Graphql::HasMarkdownDocumentation
  end
end
