# frozen_string_literal: true

module Mutations
  module TeamMembers
    class AssignRoles < BaseMutation
      description 'Invite a new member to a team.'

      field :team_member_roles, [Types::TeamMemberRoleType], description: 'The newly created team member'

      argument :member_id, Types::GlobalIdType[::TeamMember],
               description: 'The id of the member which should be assigned the roles'
      argument :role_ids, [Types::GlobalIdType[::TeamRole]],
               description: 'The roles the member should be assigned to the member'
      argument :team_id, Types::GlobalIdType[::Team], description: 'The id of the team which this member will belong to'

      def resolve(team_id:, member_id:, role_ids:)
        team = SagittariusSchema.object_from_id(team_id)
        member = SagittariusSchema.object_from_id(member_id)
        roles = role_ids.map { |id| SagittariusSchema.object_from_id(id) }

        return { team_member_roles: nil, errors: [create_message_error('Invalid team')] } if team.nil?
        return { team_member_roles: nil, errors: [create_message_error('Invalid member')] } if member.nil?
        return { team_member_roles: nil, errors: [create_message_error('Invalid role')] } if roles.any?(&:nil?)

        ::TeamMembers::AssignRolesService.new(
          current_user,
          team,
          member,
          roles
        ).execute.to_mutation_response(success_key: :team_member_roles)
      end
    end
  end
end
