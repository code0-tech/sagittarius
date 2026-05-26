# frozen_string_literal: true

module Mutations
  module Users
    class CreateCraterToken < BaseMutation
      description '(Cloud only) Create a token for crater authentication'

      field :token, Types::CraterTokenType, null: true, description: 'The created token'

      def resolve
        unless current_authentication&.session?
          return {
            token: nil,
            errors: [
              create_error(:unsupported_authentication, 'This mutation can only be used with a UserSession')
            ],
          }
        end

        {
          token: {
            user: current_authentication.user,
            token: current_authentication.user.generate_token_for(:crater_login),
          },
          errors: [],
        }
      end
    end
  end
end
