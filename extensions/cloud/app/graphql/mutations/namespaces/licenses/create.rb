# frozen_string_literal: true

module Mutations
  module Namespaces
    module Licenses
      class Create < BaseMutation
        description '(Cloud only) Create a new namespace license.'

        field :license, Types::LicenseType, null: true, description: 'The newly created license.'

        argument :data, String, required: true, description: 'The license data.'
        argument :namespace_id, ::Types::GlobalIdType[::Namespace], required: true,
                                                                    description: 'The namespace ID.'

        def resolve(namespace_id:, data:)
          namespace = SagittariusSchema.object_from_id(namespace_id)

          if namespace.nil?
            return { license: nil,
                     errors: [create_error(:namespace_not_found, 'Invalid namespace')] }
          end

          ::Namespaces::Licenses::CreateService.new(
            current_authentication,
            namespace: namespace,
            data: data
          ).execute.to_mutation_response(success_key: :license)
        end
      end
    end
  end
end
