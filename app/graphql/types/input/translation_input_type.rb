# frozen_string_literal: true

module Types
  module Input
    class TranslationInputType < Types::BaseInputObject
      description 'Represents a translation'

      argument :code, String,
               required: true,
               description: 'Code of the translation'
      argument :content, String,
               required: true,
               description: 'Content of the translation'
    end
  end
end
