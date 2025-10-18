# frozen_string_literal: true

module Mutations
  module Users
    class PasswordResetRequest < BaseMutation
      description 'Request an password reset'

      argument :email, String, required: true,
                               description: 'Email of the user to reset the password'

      field :message, String, null: true,
                              description: 'A message indicating the result of the password reset request'

      def resolve(email:)
        user = User.where(email: email).where.not(email_verified_at: nil).first
        message = ::Users::PasswordResetRequestService.new(
          user
        ).execute.message
        { message: message, errors: [] }
      end
    end
  end
end
