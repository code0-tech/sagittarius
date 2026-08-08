# frozen_string_literal: true

class RuntimeModuleStatusPolicy < BasePolicy
  delegate { subject.runtime_module }
end
