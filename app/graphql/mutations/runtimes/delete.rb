# frozen_string_literal: true

module Mutations
  module Runtimes
    class Delete < BaseMutation
      include Sagittarius::Graphql::AuthorizationBypass

      description 'Delete an existing runtime.'

      field :runtime, Types::RuntimeType, null: true, description: 'The updated organization.'

      argument :runtime_id, Types::GlobalIdType[::Runtime], required: true,
                                                            description: 'The runtime to delete.'

      def resolve(runtime_id:)
        runtime = SagittariusSchema.object_from_id(runtime_id)

        if runtime.nil?
          return { runtime: nil,
                   errors: [create_message_error('Invalid runtime')] }
        end

        ::Runtimes::DeleteService.new(
          current_user,
          runtime
        ).execute.to_mutation_response(success_key: :runtime)
      end
    end
  end
end
