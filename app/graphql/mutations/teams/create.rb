# frozen_string_literal: true

module Mutations
  module Teams
    class Create < BaseMutation
      description 'Create a new team.'

      field :team, Types::TeamType, null: true, description: 'The newly created team.'

      argument :name, String, required: true, description: 'Name for the new team.'

      def resolve(name:)
        ::Teams::CreateService.new(current_user, name: name).execute.to_mutation_response(success_key: :team)
      end
    end
  end
end
