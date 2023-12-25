# frozen_string_literal: true

module Types
  module Errors
    class MessageErrorType < Types::BaseObject
      description 'Represents an error message'

      field :message, String, null: false, description: 'The message provided from the error'
    end
  end
end
