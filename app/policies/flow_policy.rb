# frozen_string_literal: true

class FlowPolicy < BasePolicy
  delegate { subject.project }

  rule { can?(:read_flow) }.enable :trigger_execution
end
