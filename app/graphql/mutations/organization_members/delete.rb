# frozen_string_literal: true

module Mutations
  module OrganizationMembers
    class Delete < BaseMutation
      description 'Remove a new member to an organization.'

      field :organization_member, Types::OrganizationMemberType, description: 'The removed organization member'

      argument :organization_member_id, Types::GlobalIdType[::OrganizationMember],
               description: 'The id of the organization member which will removed'

      def resolve(organization_member_id:)
        organization_member = SagittariusSchema.object_from_id(organization_member_id)

        if organization_member.nil?
          return { organization_member: nil,
                   errors: [create_message_error('Invalid member')] }
        end

        ::OrganizationMembers::DeleteService.new(
          current_user,
          organization_member
        ).execute.to_mutation_response(success_key: :organization_member)
      end
    end
  end
end
