# frozen_string_literal: true

module Mutations
  module Users
    class Logout < BaseMutation
      description 'Logout an existing user session'

      field :user_session, Types::UserSessionType, null: true, description: 'The logged out user session'

      argument :user_session_id, Types::GlobalIdType[::UserSession], required: true,
                                                                     description: 'ID of the session to logout'

      def resolve(user_session_id:)
        user_session = SagittariusSchema.object_from_id(user_session_id)

        return { user_session: nil, errors: [create_message_error('Invalid user session')] } if user_session.nil?

        ::Users::LogoutService.new(
          current_authentication,
          user_session
        ).execute.to_mutation_response(success_key: :user_session)
      end
    end
  end
end
