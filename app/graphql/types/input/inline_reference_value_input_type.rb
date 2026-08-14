# frozen_string_literal: true

module Types
  module Input
    class InlineReferenceValueInputType < Types::BaseInputObject
      description 'Input type for an inline reference value'

      argument :signature, String,
               required: true, description: 'The key addressed via `${signature}` inside the literal value'
      argument :value, -> { Types::Input::NodeParameterValueInputType },
               required: true, description: 'The value this reference resolves to'
    end
  end
end
