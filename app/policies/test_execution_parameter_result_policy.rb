# frozen_string_literal: true

class TestExecutionParameterResultPolicy < BasePolicy
  delegate { subject.test_execution_node_result }
end
