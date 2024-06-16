# frozen_string_literal: true

module Mutations
  module NamespaceLicenses
    class Delete < BaseMutation
      description 'Deletes an namespace license.'

      field :namespace_license, Types::NamespaceLicenseType, null: true,
                                                             description: 'The deleted namespace license.'

      argument :namespace_license_id, ::Types::GlobalIdType[::NamespaceLicense],
               required: true,
               description: 'The license id to delete.'

      def resolve(namespace_license_id:)
        license = SagittariusSchema.object_from_id(namespace_license_id)

        if license.nil?
          return { organization_license: nil,
                   errors: [create_message_error('Invalid license')] }
        end

        ::NamespaceLicenses::DeleteService.new(
          current_user,
          namespace_license: license
        ).execute.to_mutation_response(success_key: :namespace_license)
      end
    end
  end
end
