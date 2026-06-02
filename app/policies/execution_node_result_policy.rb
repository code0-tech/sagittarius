# frozen_string_literal: true

class ExecutionNodeResultPolicy < BasePolicy
  delegate { subject.execution_result }
end
