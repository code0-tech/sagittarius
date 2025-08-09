# frozen_string_literal: true

class FunctionDefinitionPolicy < BasePolicy
  delegate { subject.runtime_function_definition }
end
