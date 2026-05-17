# frozen_string_literal: true

module Licenses
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :data

    def initialize(current_authentication, data:)
      @current_authentication = current_authentication
      @data = data
    end

    def execute
      unless Ability.allowed?(current_authentication, :create_license)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      transactional do |t|
        license = License.create(data: data)
        unless license.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to create license',
            error_code: :invalid_license,
            details: license.errors
          )
        end

        license_data = license.license

        AuditService.audit(
          :license_created,
          author_id: current_authentication.user.id,
          entity: license,
          target: AuditEvent::GLOBAL_TARGET,
          details: {
            licensee: license_data.licensee,
            start_date: license_data.start_date,
            end_date: license_data.end_date,
            restrictions: license_data.restrictions,
            options: license_data.options,
          }
        )

        ServiceResponse.success(message: 'Created new license', payload: license)
      end
    end
  end
end
