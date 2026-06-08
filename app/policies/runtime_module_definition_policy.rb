# frozen_string_literal: true

class RuntimeModuleDefinitionPolicy < BasePolicy
  delegate { subject.runtime_module }
end
