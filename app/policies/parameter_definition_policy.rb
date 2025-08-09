# frozen_string_literal: true

class ParameterDefinitionPolicy < BasePolicy
  delegate { subject.runtime_parameter_definition }
end
