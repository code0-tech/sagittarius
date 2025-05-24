# frozen_string_literal: true

class FlowTypePolicy < BasePolicy
  delegate { subject.runtime }
end
