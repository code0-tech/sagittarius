# frozen_string_literal: true

class ExecutionResultPolicy < BasePolicy
  delegate { subject.flow }
end
