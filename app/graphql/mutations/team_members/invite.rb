# frozen_string_literal: true

module Mutations
  module TeamMembers
    class Invite < BaseMutation
      description 'Invite a new member to an organization.'

      field :organization_member, Types::OrganizationMemberType, description: 'The newly created organization member'

      argument :organization_id, Types::GlobalIdType[::Organization],
               description: 'The id of the organization which this member will belong to'
      argument :user_id, Types::GlobalIdType[::User], description: 'The id of the user to invite'

      def resolve(organization_id:, user_id:)
        organization = SagittariusSchema.object_from_id(organization_id)
        user = SagittariusSchema.object_from_id(user_id)

        return { organization_member: nil, errors: [create_message_error('Invalid organization')] } if organization.nil?
        return { organization_member: nil, errors: [create_message_error('Invalid user')] } if user.nil?

        ::TeamMembers::InviteService.new(
          current_user,
          organization,
          user
        ).execute.to_mutation_response(success_key: :organization_member)
      end
    end
  end
end
