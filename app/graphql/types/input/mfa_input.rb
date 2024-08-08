# frozen_string_literal: true

module Types
  module Input
    class MfaInput < ::Types::BaseInputObject
      description 'Represents the input for mfa authentication'

      argument :type, Types::MfaTypeEnum, required: true, description: 'The type of the mfa authentication'

      argument :value, String, required: true, description: 'The value of the authentication'
    end
  end
end
