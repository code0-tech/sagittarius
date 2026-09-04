# frozen_string_literal: true

module CLOUD
  module Types
    module UserDeletionRestrictionEnum
      extend ActiveSupport::Concern

      prepended do
        value 'ACTIVE_SUBSCRIPTION',
              '(Cloud only) The current user has an active subscription.',
              value: :active_subscription
      end
    end
  end
end
