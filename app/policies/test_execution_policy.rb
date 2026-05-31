# frozen_string_literal: true

class TestExecutionPolicy < BasePolicy
  delegate { subject.flow }
end
