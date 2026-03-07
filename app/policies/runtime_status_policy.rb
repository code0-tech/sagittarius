# frozen_string_literal: true

class RuntimeStatusPolicy < BasePolicy
  delegate { subject.runtime }
end
