# frozen_string_literal: true

module EE
  module ErrorCode
    extend ActiveSupport::Concern

    class_methods do
      include Sagittarius::Override

      override :error_codes
      def error_codes
        super.merge(
          {
            invalid_license: { description: 'The license is invalid because of active model errors' },
            license_not_found: { description: 'The license with the given identifier was not found' },
            no_free_license_seats: { description: 'There are no free license seats to complete this operation' },
            ai_usage_limit_exceeded: { description: 'The AI usage limit has been exceeded for the billing cycle' },
          }
        )
      end
    end
  end
end
