# frozen_string_literal: true

class RuntimeFlowTypeSettingPolicy < BasePolicy
  delegate { subject.runtime_flow_type }
end
