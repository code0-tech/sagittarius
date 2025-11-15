# frozen_string_literal: true

module Namespaces
  module Licenses
    class CreateService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace, :data

      def initialize(current_authentication, namespace:, data:)
        @current_authentication = current_authentication
        @namespace = namespace
        @data = data
      end

      def execute
        unless Ability.allowed?(current_authentication, :create_namespace_license, namespace)
          return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
        end

        transactional do |t|
          namespace_license = NamespaceLicense.create(data: data, namespace: namespace)
          unless namespace_license.persisted?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to create namespace license',
              error_code: :invalid_namespace_license,
              details: namespace_license.errors
            )
          end

          license_data = namespace_license.license

          AuditService.audit(
            :namespace_license_created,
            author_id: current_authentication.user.id,
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
end
