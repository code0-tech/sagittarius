# frozen_string_literal: true

class ExecutionParameterResultPolicy < BasePolicy
  delegate { subject.execution_node_result }
end
