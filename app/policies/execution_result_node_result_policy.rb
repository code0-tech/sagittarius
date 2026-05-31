# frozen_string_literal: true

class ExecutionResultNodeResultPolicy < BasePolicy
  delegate { subject.execution_result }
end
