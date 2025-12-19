# frozen_string_literal: true

class ParameterDefinitionPolicy < BasePolicy
  delegate { subject.runtime_parameter_definition }

  rule { can?(:read_runtime_parameter_definition) }.policy do
    enable :read_parameter_definition
  end
end
