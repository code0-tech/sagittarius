# frozen_string_literal: true

module EE
  module ErrorCode
    extend ActiveSupport::Concern

    class_methods do
      def error_codes
        super.merge(
          {
            invalid_license: { description: 'The license is invalid because of active model errors' },
            license_not_found: { description: 'The license with the given identifier was not found' },
            no_free_license_seats: { description: 'There are no free license seats to complete this operation' },
          }
        )
      end
    end
  end
end
