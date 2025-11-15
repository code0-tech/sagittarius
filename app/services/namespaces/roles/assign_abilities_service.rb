# frozen_string_literal: true

module Namespaces
  module Roles
    class AssignAbilitiesService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :role, :abilities

      def initialize(current_authentication, role, abilities)
        @current_authentication = current_authentication
        @role = role
        @abilities = abilities
      end

      def execute
        namespace = role.namespace
        unless Ability.allowed?(current_authentication, :assign_role_abilities, role)
          return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
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
            author_id: current_authentication.user.id,
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
            error_code: :cannot_remove_last_admin_ability
          )
        end
      end
    end
  end
end
