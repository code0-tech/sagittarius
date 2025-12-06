# frozen_string_literal: true

class RuntimePolicy < BasePolicy
  delegate { subject.namespace || :global }

  rule { can?(:read_runtime) }.policy do
    enable :read_data_type
    enable :read_runtime_function_definition
    enable :read_runtime_parameter_definition
  end
end
