# frozen_string_literal: true

module Mutations
  module TeamRoles
    class AssignAbilities < BaseMutation
      description 'Update the abilities a role is granted.'

      field :abilities, [Types::TeamRoleAbilityEnum], description: 'The now granted abilities'

      argument :abilities, [Types::TeamRoleAbilityEnum],
               description: 'The abilities that should be granted to the ability'
      argument :role_id, Types::GlobalIdType[::TeamRole],
               description: 'The id of the role which should be granted the abilities'

      def resolve(role_id:, abilities:)
        role = SagittariusSchema.object_from_id(role_id)

        return { abilities: nil, errors: [create_message_error('Invalid role')] } if role.nil?

        ::TeamRoles::AssignAbilitiesService.new(
          current_user,
          role,
          abilities
        ).execute.to_mutation_response(success_key: :abilities)
      end
    end
  end
end
