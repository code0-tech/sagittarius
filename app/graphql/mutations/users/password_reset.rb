# frozen_string_literal: true

module Mutations
  module Users
    class PasswordReset < BaseMutation
      description 'Reset the password using a reset token'

      argument :reset_token, String, required: true,
                                     description: 'The password reset token sent to the user email'

      argument :new_password, String, required: true,
                                      description: 'The new password to set for the user'
      argument :new_password_confirmation, String, required: true, description:
                 'The confirmation of the new password to set for the user needs to be the same as the new password'

      field :message, String, null: true,
                              description: 'A message indicating the result of the password reset request'

      def resolve(reset_token:, new_password:, new_password_confirmation:)
        if new_password != new_password_confirmation
          return { user: nil,
                   errors: [create_error(:invalid_password_repeat, 'Invalid password repeat')] }
        end

        message = ::Users::PasswordResetService.new(
          reset_token,
          new_password
        ).execute.message
        { message: message, errors: [] }
      end
    end
  end
end
