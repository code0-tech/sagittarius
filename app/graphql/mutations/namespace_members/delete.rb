# frozen_string_literal: true

module Mutations
  module NamespaceMembers
    class Delete < BaseMutation
      description 'Remove a member from a namespace.'

      field :namespace_member, Types::NamespaceMemberType, description: 'The removed namespace member'

      argument :namespace_member_id, Types::GlobalIdType[::NamespaceMember],
               description: 'The id of the namespace member to remove'

      def resolve(namespace_member_id:)
        namespace_member = SagittariusSchema.object_from_id(namespace_member_id)

        if namespace_member.nil?
          return { namespace_member: nil,
                   errors: [create_message_error('Invalid member')] }
        end

        ::NamespaceMembers::DeleteService.new(
          current_user,
          namespace_member
        ).execute.to_mutation_response(success_key: :namespace_member)
      end
    end
  end
end
