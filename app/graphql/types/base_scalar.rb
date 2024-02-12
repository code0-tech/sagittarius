# frozen_string_literal: true

module Types
  class BaseScalar < GraphQL::Schema::Scalar
    include Sagittarius::Graphql::HasMarkdownDocumentation
  end
end
