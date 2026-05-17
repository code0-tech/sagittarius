# frozen_string_literal: true

class RuntimeModulePolicy < BasePolicy
  delegate { subject.runtime }
end
