# frozen_string_literal: true

class RuntimeFeaturePolicy < BasePolicy
  delegate { subject.runtime_status }
end
