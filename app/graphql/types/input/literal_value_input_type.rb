# frozen_string_literal: true

module Types
  module Input
    class LiteralValueInputType < Types::BaseInputObject
      description 'Input type for a literal value with inline references'

      argument :references, [Types::Input::InlineReferenceValueInputType],
               required: false, description: 'Inline references addressable via `${signature}` inside `value`'
      argument :value, GraphQL::Types::JSON,
               required: false, description: 'The literal value itself'
    end
  end
end
