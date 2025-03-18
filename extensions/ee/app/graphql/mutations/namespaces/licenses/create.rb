# frozen_string_literal: true

module Mutations
  module Namespaces
    module Licenses
      class Create < BaseMutation
        description 'Create a new namespace license.'

        field :namespace_license, Types::NamespaceLicenseType, null: true, description: 'The newly created license.'

        argument :data, String, required: true, description: 'The license data.'
        argument :namespace_id, ::Types::GlobalIdType[::Namespace], required: true,
                                                                    description: 'The namespace ID.'

        def resolve(namespace_id:, data:)
          namespace = SagittariusSchema.object_from_id(namespace_id)

          if namespace.nil?
            return { namespace_license: nil,
                     errors: [create_message_error('Invalid namespace')] }
          end

          ::Namespaces::Licenses::CreateService.new(
            current_authentication,
            namespace: namespace,
            data: data
          ).execute.to_mutation_response(success_key: :namespace_license)
        end
      end
    end
  end
end
