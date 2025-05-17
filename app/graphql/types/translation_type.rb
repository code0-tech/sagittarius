# frozen_string_literal: true

module Types
  class TranslationType < Types::BaseObject
    description 'Represents a translation'

    field :code, String, null: false, description: 'Code of the translation'
    field :content, String, null: false, description: 'Content of the translation'
  end
end
