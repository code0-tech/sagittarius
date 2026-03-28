# frozen_string_literal: true

module Types
  class FlowValidationStatusEnum < Types::BaseEnum
    description 'The validation status of a flow.'

    value :UNVALIDATED, 'The flow has not been validated yet.', value: 'unvalidated'
    value :VALID, 'The flow has been validated and is valid.', value: 'valid'
    value :INVALID, 'The flow has been validated and is invalid.', value: 'invalid'
  end
end
