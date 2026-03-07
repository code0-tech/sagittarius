# frozen_string_literal: true

class RuntimeStatusConfigurationPolicy < BasePolicy
  delegate { subject.runtime_status }
end
