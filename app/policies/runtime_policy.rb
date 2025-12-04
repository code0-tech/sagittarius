# frozen_string_literal: true

class RuntimePolicy < BasePolicy
  delegate { subject.namespace || :global }

  rule { can?(:read_runtime) }.policy do
    enable :read_data_type
  end
end
