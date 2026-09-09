# frozen_string_literal: true

module Types
  class LicenseCustomerTypeEnum < Types::BaseEnum
    description '(EE only) The type of the customer that owns a license subscription.'

    value 'PERSONAL', 'A personal customer.', value: 'personal'
    value 'BUSINESS', 'A business customer.', value: 'business'
  end
end
