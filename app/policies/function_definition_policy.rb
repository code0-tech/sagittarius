# frozen_string_literal: true

class FunctionDefinitionPolicy < BasePolicy
  delegate { subject.runtime_function_definition }

  rule { can?(:read_runtime_function_definition) }.policy do
    enable :read_function_definition
  end
end
