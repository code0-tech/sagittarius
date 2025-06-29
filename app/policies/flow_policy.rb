# frozen_string_literal: true

class FlowPolicy < BasePolicy
  delegate { subject.project }
end
