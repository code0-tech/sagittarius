# frozen_string_literal: true

class ActionStatusPolicy < BasePolicy
  delegate { subject.runtime }
end
