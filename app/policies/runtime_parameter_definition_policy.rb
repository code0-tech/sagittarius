# frozen_string_literal: true

class RuntimeParameterDefinitionPolicy < BasePolicy
  delegate { subject.runtime_function_definition }
end
