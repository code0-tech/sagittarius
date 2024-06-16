# frozen_string_literal: true

module Mutations
  module NamespaceMembers
    class AssignRoles < BaseMutation
      description 'Update the roles a member is assigned to.'

      field :namespace_member_roles, [Types::NamespaceMemberRoleType],
            description: 'The roles the member is now assigned to'

      argument :member_id, Types::GlobalIdType[::NamespaceMember],
               description: 'The id of the member which should be assigned the roles'
      argument :role_ids, [Types::GlobalIdType[::NamespaceRole]],
               description: 'The roles the member should be assigned to the member'

      def resolve(member_id:, role_ids:)
        member = SagittariusSchema.object_from_id(member_id)
        roles = role_ids.map { |id| SagittariusSchema.object_from_id(id) }

        return { namespace_member_roles: nil, errors: [create_message_error('Invalid member')] } if member.nil?
        return { namespace_member_roles: nil, errors: [create_message_error('Invalid role')] } if roles.any?(&:nil?)

        ::NamespaceMembers::AssignRolesService.new(
          current_user,
          member,
          roles
        ).execute.to_mutation_response(success_key: :namespace_member_roles)
      end
    end
  end
end
