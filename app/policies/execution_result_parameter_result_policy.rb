# frozen_string_literal: true

class ExecutionResultParameterResultPolicy < BasePolicy
  delegate { subject.execution_result_node_result }
end
