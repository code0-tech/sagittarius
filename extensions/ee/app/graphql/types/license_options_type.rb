# frozen_string_literal: true

module Types
  class LicenseOptionsType < Types::BaseObject
    description '(EE only) Represents the options of a license'

    field :customer_type, Types::LicenseCustomerTypeEnum, null: true,
                                                          description: 'Type of the customer that owns the subscription'
    field :payment_period, Types::LicensePaymentPeriodEnum, null: true, description: 'Subscription payment period'
    field :plan, Types::LicensePlanEnum, null: true, description: 'Checkout plan of the subscription'
  end
end
