# frozen_string_literal: true

module Mutations
  module Namespaces
    module Members
      class Invite < BaseMutation
        description 'Invite a new member to a namespace.'

        field :namespace_member, Types::NamespaceMemberType, description: 'The newly created namespace member'

        argument :namespace_id, Types::GlobalIdType[::Namespace],
                 description: 'The id of the namespace which this member will belong to'
        argument :user_id, Types::GlobalIdType[::User], description: 'The id of the user to invite'

        def resolve(namespace_id:, user_id:)
          namespace = SagittariusSchema.object_from_id(namespace_id)
          user = SagittariusSchema.object_from_id(user_id)

          return { namespace_member: nil, errors: [create_message_error('Invalid namespace')] } if namespace.nil?
          return { namespace_member: nil, errors: [create_message_error('Invalid user')] } if user.nil?

          ::Namespaces::Members::InviteService.new(
            current_authentication,
            namespace,
            user
          ).execute.to_mutation_response(success_key: :namespace_member)
        end
      end
    end
  end
end
