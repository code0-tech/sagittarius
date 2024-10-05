# frozen_string_literal: true

module Types
  module Input
    class IdentityInput < ::Types::BaseInputObject
      description 'Represents the input for external user identity validation'

      argument :code, String, required: false,
                              description: 'This validation code will be used for the oAuth validation process'
    end
  end
end
