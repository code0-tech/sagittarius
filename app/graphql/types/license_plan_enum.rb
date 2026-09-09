# frozen_string_literal: true

module Types
  class LicensePlanEnum < Types::BaseEnum
    description '(EE only) The checkout plan of a license subscription.'

    value 'PRO', 'The Pro plan.', value: 'PRO'
    value 'MAX', 'The Max plan.', value: 'MAX'
    value 'CUSTOM', 'A custom plan.', value: 'CUSTOM'
  end
end
