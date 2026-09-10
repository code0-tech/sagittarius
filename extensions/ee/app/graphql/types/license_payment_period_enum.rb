# frozen_string_literal: true

module Types
  class LicensePaymentPeriodEnum < Types::BaseEnum
    description '(EE only) The payment period of a license subscription.'

    value 'MONTHLY', 'Billed monthly.', value: 'monthly'
    value 'QUARTERLY', 'Billed quarterly.', value: 'quarterly'
    value 'YEARLY', 'Billed yearly.', value: 'yearly'
  end
end
