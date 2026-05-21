# frozen_string_literal: true

class ExecutionRuntimeStatusPolicy < BasePolicy
  delegate { subject.runtime }
end
