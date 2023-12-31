# frozen_string_literal: true

module Mutations
  module TeamRoles
    class Create < BaseMutation
      description 'Create a new role in a team.'

      field :team_role, Types::TeamRoleType, description: 'The newly created team role'

      argument :name, String, description: 'The name for the new role'
      argument :team_id, Types::GlobalIdType[::Team], description: 'The id of the team which this role will belong to'

      def resolve(team_id:, **params)
        team = SagittariusSchema.object_from_id(team_id)

        return { team_role: nil, errors: [create_message_error('Invalid team')] } if team.nil?

        ::TeamRoles::CreateService.new(current_user, team, params).execute.to_mutation_response(success_key: :team_role)
      end
    end
  end
end
