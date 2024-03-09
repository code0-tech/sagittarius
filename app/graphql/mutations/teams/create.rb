# frozen_string_literal: true

module Mutations
  module Teams
    class Create < BaseMutation
      description 'Create a new organization.'

      field :organization, Types::OrganizationType, null: true, description: 'The newly created organization.'

      argument :name, String, required: true, description: 'Name for the new organization.'

      def resolve(name:)
        ::Teams::CreateService.new(current_user, name: name).execute.to_mutation_response(success_key: :organization)
      end
    end
  end
end
