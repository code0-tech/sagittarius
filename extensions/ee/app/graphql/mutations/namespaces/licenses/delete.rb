# frozen_string_literal: true

module Mutations
  module Namespaces
    module Licenses
      class Delete < BaseMutation
        description '(EE only) Deletes an namespace license.'

        field :namespace_license, Types::NamespaceLicenseType, null: true,
                                                               description: 'The deleted namespace license.'

        argument :namespace_license_id, ::Types::GlobalIdType[::NamespaceLicense],
                 required: true,
                 description: 'The license id to delete.'

        def resolve(namespace_license_id:)
          license = SagittariusSchema.object_from_id(namespace_license_id)

          if license.nil?
            return { organization_license: nil,
                     errors: [create_error(:license_not_found, 'Invalid license')] }
          end

          ::Namespaces::Licenses::DeleteService.new(
            current_authentication,
            namespace_license: license
          ).execute.to_mutation_response(success_key: :namespace_license)
        end
      end
    end
  end
end
