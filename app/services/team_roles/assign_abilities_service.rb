# frozen_string_literal: true

module TeamRoles
  class AssignAbilitiesService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :role, :abilities

    def initialize(current_user, role, abilities)
      @current_user = current_user
      @role = role
      @abilities = abilities
    end

    def execute
      team = role.team
      unless Ability.allowed?(current_user, :assign_role_abilities, team)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        current_abilities = role.abilities
        old_abilities_for_audit_event = current_abilities.map(&:ability)

        current_abilities.where.not(ability: abilities).delete_all

        (abilities - current_abilities.map(&:ability)).map do |ability|
          organization_role_ability = OrganizationRoleAbility.create(organization_role: role, ability: ability)

          next if organization_role_ability.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to save organization role ability',
            payload: organization_role_ability.errors
          )
        end

        new_abilities = role.reload.abilities.map(&:ability)

        AuditService.audit(
          :organization_role_abilities_updated,
          author_id: current_user.id,
          entity: role,
          details: {
            old_abilities: old_abilities_for_audit_event,
            new_abilities: new_abilities,
          },
          target: team
        )

        ServiceResponse.success(message: 'Role abilities updated', payload: new_abilities)
      end
    end
  end
end
