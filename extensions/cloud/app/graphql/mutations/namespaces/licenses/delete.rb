# frozen_string_literal: true

module Mutations
  module Namespaces
    module Licenses
      class Delete < BaseMutation
        description '(Cloud only) Deletes an namespace license.'

        field :license, Types::LicenseType,
              null: true,
              description: 'The deleted license.'

        argument :license_id, ::Types::GlobalIdType[::License],
                 required: true,
                 description: 'The license id to delete.'

        def resolve(license_id:)
          license = SagittariusSchema.object_from_id(license_id)

          if license.nil?
            return { license: nil,
                     errors: [create_error(:license_not_found, 'Invalid license')] }
          end

          ::Namespaces::Licenses::DeleteService.new(
            current_authentication,
            license: license
          ).execute.to_mutation_response(success_key: :license)
        end
      end
    end
  end
end
