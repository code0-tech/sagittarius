# frozen_string_literal: true

module Users
  class UpdateNamespacePinsService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user, :namespace_ids

    def initialize(current_authentication, namespace_ids)
      @current_authentication = current_authentication
      @user = current_authentication&.user
      @namespace_ids = namespace_ids.uniq
    end

    def execute
      unless Ability.allowed?(current_authentication, :update_user_namespace_pin, user)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      namespaces = NamespacesFinder.new(id: namespace_ids, namespace_member_user: user).execute
      if namespaces.count != namespace_ids.count
        return ServiceResponse.error(message: 'Namespace not found', error_code: :namespace_not_found)
      end

      transactional do |t|
        UserNamespacePin.where(user: user).delete_all

        namespace_ids.each_with_index do |namespace_id, priority|
          pin = user.user_namespace_pins.create(namespace_id: namespace_id, priority: priority)
          next if pin.persisted?

          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update user namespace pins',
            error_code: :invalid_user_namespace_pin,
            details: pin.errors
          )
        end

        AuditService.audit(
          :user_namespace_pins_updated,
          author_id: user.id,
          entity: user,
          target: user,
          details: { namespace_ids: namespace_ids }
        )

        ServiceResponse.success(message: 'Updated user namespace pins', payload: user)
      end
    end
  end
end
