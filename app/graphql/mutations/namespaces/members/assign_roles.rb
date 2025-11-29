# frozen_string_literal: true

module Mutations
  module Namespaces
    module Members
      class AssignRoles < BaseMutation
        description 'Update the roles a member is assigned to.'

        field :member, Types::NamespaceMemberType,
              description: 'The member which was assigned the roles', null: true

        argument :member_id, Types::GlobalIdType[::NamespaceMember],
                 description: 'The id of the member which should be assigned the roles'
        argument :role_ids, [Types::GlobalIdType[::NamespaceRole]],
                 description: 'The roles the member should be assigned to the member'

        def resolve(member_id:, role_ids:)
          member = SagittariusSchema.object_from_id(member_id)
          roles = role_ids.map { |id| SagittariusSchema.object_from_id(id) }

          if member.nil?
            return { namespace_member_roles: nil,
                     errors: [create_error(:namespace_member_not_found, 'Invalid member')] }
          end
          if roles.any?(&:nil?)
            return { namespace_member_roles: nil,
                     errors: [create_error(:namespace_role_not_found, 'Invalid role')] }
          end

          ::Namespaces::Members::AssignRolesService.new(
            current_authentication,
            member,
            roles
          ).execute.to_mutation_response(success_key: :member)
        end
      end
    end
  end
end
