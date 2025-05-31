# frozen_string_literal: true

class FlowSettingPolicy < BasePolicy
  delegate { subject.flow }
end
