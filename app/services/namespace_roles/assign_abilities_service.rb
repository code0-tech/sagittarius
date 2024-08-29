# frozen_string_literal: true

module NamespaceRoles
  class AssignAbilitiesService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :role, :abilities

    def initialize(current_user, role, abilities)
      @current_user = current_user
      @role = role
      @abilities = abilities
    end

    def execute
      namespace = role.namespace
      unless Ability.allowed?(current_user, :assign_role_abilities, namespace)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        current_abilities = role.abilities
        old_abilities_for_audit_event = current_abilities.map(&:ability)

        check_admin_existing(t)

        current_abilities.where.not(ability: abilities).delete_all

        (abilities - current_abilities.map(&:ability)).map do |ability|
          organization_role_ability = NamespaceRoleAbility.create(namespace_role: role, ability: ability)

          next if organization_role_ability.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to save namespace role ability',
            payload: organization_role_ability.errors
          )
        end

        new_abilities = role.reload.abilities.map(&:ability)

        AuditService.audit(
          :namespace_role_abilities_updated,
          author_id: current_user.id,
          entity: role,
          details: {
            old_abilities: old_abilities_for_audit_event,
            new_abilities: new_abilities,
          },
          target: namespace
        )

        ServiceResponse.success(message: 'Role abilities updated', payload: new_abilities)
      end
    end

    private

    def check_admin_existing(t)
      return if role.namespace.has_owner?

      unless role.namespace.roles.where.not(id: role.id)
                 .joins(:abilities)
                 .exists?(abilities: { ability: :namespace_administrator }) ||
             abilities.include?(:namespace_administrator)
        t.rollback_and_return! ServiceResponse.error(
          message: 'Cannot remove the last administrator ability',
          payload: :cannot_remove_last_admin_ability
        )
      end
    end
  end
end
