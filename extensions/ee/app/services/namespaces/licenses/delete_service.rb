# frozen_string_literal: true

module Namespaces
  module Licenses
    class DeleteService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace_license

      def initialize(current_authentication, namespace_license:)
        @current_authentication = current_authentication
        @namespace_license = namespace_license
      end

      def execute
        unless Ability.allowed?(current_authentication, :delete_namespace_license, namespace_license.namespace)
          return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
        end

        transactional do |t|
          namespace_license.delete
          if namespace_license.persisted?
            t.rollback_and_return! ServiceResponse.error(
              message: 'Failed to delete namespace license',
              payload: namespace_license.errors
            )
          end

          AuditService.audit(
            :namespace_license_deleted,
            author_id: current_authentication.user.id,
            entity: namespace_license,
            details: {},
            target: namespace_license.namespace
          )

          ServiceResponse.success(message: 'Deleted namespace license', payload: namespace_license)
        end
      end
    end
  end
end
