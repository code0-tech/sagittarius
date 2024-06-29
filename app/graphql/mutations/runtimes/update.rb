# frozen_string_literal: true

module Mutations
  module Runtimes
    class Update < BaseMutation
      description 'Update an existing runtime.'

      field :runtime, Types::RuntimeType, null: true, description: 'The updated runtime.'

      argument :runtime_id, Types::GlobalIdType[::Runtime],
               required: true,
               description: 'ID of the runtime to update.'

      argument :description, String, required: false, description: 'Description for the new runtime.'
      argument :name, String, required: false, description: 'Name for the new runtime.'

      def resolve(runtime_id:, **params)
        runtime = SagittariusSchema.object_from_id(runtime_id)

        return { runtime: nil, errors: [create_message_error('Invalid runtime')] } if runtime.nil?

        ::Runtimes::UpdateService.new(
          current_user,
          runtime,
          params
        ).execute.to_mutation_response(success_key: :runtime)
      end
    end
  end
end
