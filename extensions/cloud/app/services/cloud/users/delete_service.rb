# frozen_string_literal: true

module CLOUD
  module Users
    module DeleteService
      include Sagittarius::Override

      override :deletion_restriction
      def deletion_restriction
        restriction = super
        return restriction if restriction
        return unless user == current_authentication.user

        current_license = user.namespace&.current_license
        license_data = current_license&.license
        :active_subscription if license_data&.options&.[](:subscription)
      end

      protected

      override :validate_deletion
      def validate_deletion
        restriction = deletion_restriction
        return super unless restriction == :active_subscription

        ServiceResponse.error(
          message: 'A user with an active subscription cannot delete itself',
          error_code: :cannot_delete_user_with_active_subscription
        )
      end
    end
  end
end
