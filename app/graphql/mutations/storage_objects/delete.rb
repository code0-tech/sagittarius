# frozen_string_literal: true

module Mutations
  module StorageObjects
    class Delete < BaseMutation
      description 'Delete a stored file.'

      field :storage_object, Types::StorageObjectType, null: true, description: 'The deleted storage object.'

      argument :id, Types::GlobalIdType[::StorageObject], required: true,
                                                          description: 'GlobalID of the storage object to delete.'

      def resolve(id:)
        storage_object = SagittariusSchema.object_from_id(id)

        unless storage_object.is_a?(::StorageObject)
          return { storage_object: nil, errors: [create_error(:not_found, 'Invalid storage object')] }
        end

        ::StorageObjects::DeleteService.new(current_authentication, storage_object)
                                       .execute
                                       .to_mutation_response(success_key: :storage_object)
      end
    end
  end
end
