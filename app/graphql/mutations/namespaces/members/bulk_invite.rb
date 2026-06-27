# frozen_string_literal: true

module Mutations
  module Namespaces
    module Members
      class BulkInvite < BaseMutation
        description 'Invite multiple new members to a namespace.'

        field :namespace_members, [Types::NamespaceMemberType],
              description: 'The newly created namespace members'

        argument :namespace_id, Types::GlobalIdType[::Namespace],
                 description: 'The id of the namespace which these members will belong to'
        argument :user_ids, [Types::GlobalIdType[::User]], description: 'The ids of the users to invite'

        def resolve(namespace_id:, user_ids:)
          namespace = SagittariusSchema.object_from_id(namespace_id)
          users = user_ids.map { |id| SagittariusSchema.object_from_id(id) }

          if namespace.nil?
            return { namespace_members: nil,
                     errors: [create_error(:namespace_not_found, 'Invalid namespace')] }
          end
          if users.any?(&:nil?)
            return { namespace_members: nil,
                     errors: [create_error(:user_not_found, 'Invalid user')] }
          end

          ::Namespaces::Members::BulkInviteService.new(
            current_authentication,
            namespace,
            users
          ).execute.to_mutation_response(success_key: :namespace_members)
        end
      end
    end
  end
end
