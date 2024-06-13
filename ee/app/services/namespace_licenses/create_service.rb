# frozen_string_literal: true

module NamespaceLicenses
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace, :data

    def initialize(current_user, namespace:, data:)
      @current_user = current_user
      @namespace = namespace
      @data = data
    end

    def execute
      unless Ability.allowed?(current_user, :create_namespace_license, namespace)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        namespace_license = NamespaceLicense.create(data: data, namespace: namespace)
        unless namespace_license.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to create namespace license',
            payload: namespace_license.errors
          )
        end

        license_data = namespace_license.license

        AuditService.audit(
          :namespace_license_created,
          author_id: current_user.id,
          entity: namespace_license,
          target: namespace,
          details: {
            licensee: license_data.licensee,
            start_date: license_data.start_date,
            end_date: license_data.end_date,
            restrictions: license_data.restrictions,
            options: license_data.options,
          }
        )

        ServiceResponse.success(message: 'Created new namespace license', payload: namespace_license)
      end
    end
  end
end
