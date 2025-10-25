# frozen_string_literal: true

module EE
  module ErrorCode
    extend ActiveSupport::Concern

    class_methods do
      def error_codes
        super.merge(
          {
            no_free_license_seats: { description: 'There are no free license seats to complete this operation' },
          }
        )
      end
    end
  end
end
