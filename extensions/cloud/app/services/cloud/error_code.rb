# frozen_string_literal: true

module CLOUD
  module ErrorCode
    extend ActiveSupport::Concern

    class_methods do
      include Sagittarius::Override

      override :error_codes
      def error_codes
        super.merge(
          {
            cannot_delete_user_with_active_subscription: {
              description: 'A user with an active subscription cannot delete itself',
            },
          }
        )
      end
    end
  end
end
