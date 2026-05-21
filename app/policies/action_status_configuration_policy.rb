# frozen_string_literal: true

class ActionStatusConfigurationPolicy < BasePolicy
  delegate { subject.action_status }
end
