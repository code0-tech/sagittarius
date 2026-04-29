# frozen_string_literal: true

module Licenses
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :license

    def initialize(current_authentication, license:)
      @current_authentication = current_authentication
      @license = license
    end

    def execute
      unless Ability.allowed?(current_authentication, :delete_license, license)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      transactional do |t|
        license.delete
        if license.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to delete license',
            error_code: :invalid_license,
            details: license.errors
          )
        end

        AuditService.audit(
          :license_deleted,
          author_id: current_authentication.user.id,
          entity: license,
          details: {},
          target: AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(message: 'Deleted license', payload: license)
      end
    end
  end
end
