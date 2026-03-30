# frozen_string_literal: true

module Types
  class FlowDisabledReasonEnum < Types::BaseEnum
    description 'The disabled reason of a flow.'

    Flow::DISABLED_REASON.each do |reason, settings|
      value reason.upcase, settings[:description], value: reason.to_s
    end
  end
end
