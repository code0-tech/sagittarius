# frozen_string_literal: true

class AdapterRuntimeStatusPolicy < BasePolicy
  delegate { subject.runtime }
end
