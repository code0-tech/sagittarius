# frozen_string_literal: true

class RuntimePolicy < BasePolicy
  delegate { subject.namespace || :global }

  rule { can?(:read_runtime) }.policy do
    enable :read_datatype
    enable :read_module_configuration_definition
    enable :read_runtime_flow_type
    enable :read_runtime_flow_type_setting
    enable :read_runtime_function_definition
    enable :read_runtime_module
    enable :read_runtime_parameter_definition
  end
end
