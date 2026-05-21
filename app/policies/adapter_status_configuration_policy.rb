# frozen_string_literal: true

class AdapterStatusConfigurationPolicy < BasePolicy
  delegate { subject.adapter_runtime_status }
end
