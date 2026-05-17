# frozen_string_literal: true

class ModuleConfigurationDefinitionPolicy < BasePolicy
  delegate { subject.runtime_module }
end
