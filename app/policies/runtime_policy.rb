# frozen_string_literal: true

class RuntimePolicy < BasePolicy
  delegate { @subject.namespace || :global }
end
