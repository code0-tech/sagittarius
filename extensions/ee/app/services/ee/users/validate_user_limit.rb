# frozen_string_literal: true

module EE
  module Users
    module ValidateUserLimit
      protected

      def validate_user_limit!(t)
        license = License.current
        return if license.nil? || !license.restricted?(:user_count)
        return if User.count <= license.restrictions[:user_count]

        t.rollback_and_return! ServiceResponse.error(
          message: 'No free user seats in license',
          error_code: :no_free_license_seats
        )
      end
    end
  end
end
