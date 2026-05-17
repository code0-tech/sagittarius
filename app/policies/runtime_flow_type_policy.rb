# frozen_string_literal: true

class RuntimeFlowTypePolicy < BasePolicy
  delegate { subject.runtime }
end
