# frozen_string_literal: true

module CLOUD
  module Types
    module UserDeletionRestrictionEnum
      extend ActiveSupport::Concern

      prepended do
        value 'ACTIVE_CUSTOMER',
              '(Cloud only) The current user has access to a customer in crater.',
              value: :active_customer
      end
    end
  end
end
