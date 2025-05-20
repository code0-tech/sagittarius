# frozen_string_literal: true

class FlowTypeSettingPolicy < BasePolicy
  delegate { subject.flow_type }
end
