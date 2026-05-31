# frozen_string_literal: true

class TestExecutionNodeResultPolicy < BasePolicy
  delegate { subject.test_execution }
end
