# frozen_string_literal: true

module Mutations
  module Users
    class EmailVerification < BaseMutation
      description 'Verify your email when changing it or signing up'

      field :user, Types::UserType, null: true, description: 'The user whose email was verified'

      argument :token, String, required: true, description: 'The email verification token'

      def resolve(token:)
        ::Users::EmailVerificationService.new(
          current_authentication,
          token
        ).execute.to_mutation_response(success_key: :user)
      end
    end
  end
end
