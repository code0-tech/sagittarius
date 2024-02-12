# frozen_string_literal: true

module Mutations
  module TeamMembers
    class Invite < BaseMutation
      description 'Invite a new member to a team.'

      field :team_member, Types::TeamMemberType, description: 'The newly created team member'

      argument :team_id, Types::GlobalIdType[::Team], description: 'The id of the team which this member will belong to'
      argument :user_id, Types::GlobalIdType[::User], description: 'The id of the user to invite'

      def resolve(team_id:, user_id:)
        team = SagittariusSchema.object_from_id(team_id)
        user = SagittariusSchema.object_from_id(user_id)

        return { team_member: nil, errors: [create_message_error('Invalid team')] } if team.nil?
        return { team_member: nil, errors: [create_message_error('Invalid user')] } if user.nil?

        ::TeamMembers::InviteService.new(
          current_user,
          team,
          user
        ).execute.to_mutation_response(success_key: :team_member)
      end
    end
  end
end
