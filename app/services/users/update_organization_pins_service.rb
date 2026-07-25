# frozen_string_literal: true

module Users
  class UpdateOrganizationPinsService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user, :organization_ids

    def initialize(current_authentication, organization_ids)
      @current_authentication = current_authentication
      @user = current_authentication.user
      @organization_ids = organization_ids.uniq
    end

    def execute
      unless user && Ability.allowed?(current_authentication, :update_user_organization_pin, user)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      organizations = OrganizationsFinder.new(id: organization_ids, namespace_member_user: user).execute
      if organizations.count != organization_ids.count
        return ServiceResponse.error(message: 'Organization not found', error_code: :organization_not_found)
      end

      transactional do |t|
        old_pins = user.user_organization_pins.map do |pin|
          { organization_id: pin.organization_id, priority: pin.priority }
        end

        UserOrganizationPin.where(user: user).delete_all

        organization_ids.each_with_index do |organization_id, priority|
          pin = user.user_organization_pins.build(organization_id: organization_id, priority: priority)
          next if pin.save

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update user organization pins',
            error_code: :invalid_user_organization_pin,
            details: pin.errors
          )
        end

        new_pins = user.user_organization_pins.reload.map do |pin|
          { organization_id: pin.organization_id, priority: pin.priority }
        end

        AuditService.audit(
          :user_organization_pins_updated,
          author_id: current_authentication.user.id,
          entity: user,
          target: user,
          details: { old_pins: old_pins, new_pins: new_pins }
        )

        ServiceResponse.success(message: 'Updated user organization pins', payload: user)
      end
    end
  end
end
