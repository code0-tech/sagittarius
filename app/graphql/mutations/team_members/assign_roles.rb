# frozen_string_literal: true

module Mutations
  module TeamMembers
    class AssignRoles < BaseMutation
      description 'Update the roles a member is assigned to.'

      field :organization_member_roles, [Types::OrganizationMemberRoleType],
            description: 'The roles the member is now assigned to'

      argument :member_id, Types::GlobalIdType[::TeamMember],
               description: 'The id of the member which should be assigned the roles'
      argument :role_ids, [Types::GlobalIdType[::TeamRole]],
               description: 'The roles the member should be assigned to the member'

      def resolve(member_id:, role_ids:)
        member = SagittariusSchema.object_from_id(member_id)
        roles = role_ids.map { |id| SagittariusSchema.object_from_id(id) }

        return { organization_member_roles: nil, errors: [create_message_error('Invalid member')] } if member.nil?
        return { organization_member_roles: nil, errors: [create_message_error('Invalid role')] } if roles.any?(&:nil?)

        ::TeamMembers::AssignRolesService.new(
          current_user,
          member,
          roles
        ).execute.to_mutation_response(success_key: :organization_member_roles)
      end
    end
  end
end
