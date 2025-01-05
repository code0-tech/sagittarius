# frozen_string_literal: true

module Mutations
  module Runtimes
    class RotateToken < BaseMutation
      description 'reloads the token of an existing runtime.'

      field :runtime, Types::RuntimeType, null: true, description: 'The updated runtime.'

      argument :runtime_id, Types::GlobalIdType[::Runtime], required: true,
                                                            description: 'The runtime to rotate the token.'

      def resolve(runtime_id:)
        runtime = SagittariusSchema.object_from_id(runtime_id)

        if runtime.nil?
          return { runtime: nil,
                   errors: [create_message_error('Invalid runtime')] }
        end

        ::Runtimes::RotateTokenService.new(
          current_authentication,
          runtime
        ).execute.to_mutation_response(success_key: :runtime)
      end
    end
  end
end
