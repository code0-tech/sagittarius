# frozen_string_literal: true

module Mutations
  module Runtimes
    class Create < BaseMutation
      description 'Create a new runtime.'

      field :runtime, Types::RuntimeType, null: true, description: 'The newly created runtime.'

      argument :description, String, required: false, description: 'The description for the new runtime.'
      argument :name, String, required: true, description: 'Name for the new runtime.'
      argument :namespace_id, Types::GlobalIdType[::Namespace], required: false,
                                                                description: 'The Parent Id for the runtime.'

      def resolve(name:, namespace_id: nil, description: '')
        namespace = namespace_id.present? ? SagittariusSchema.object_from_id(namespace_id) : nil

        if namespace.nil? && namespace_id.present?
          return { runtime: nil,
                   errors: [create_message_error('Invalid namespace')] }
        end

        ::Runtimes::CreateService.new(
          current_authentication,
          namespace,
          name,
          description: description
        ).execute.to_mutation_response(success_key: :runtime)
      end
    end
  end
end
