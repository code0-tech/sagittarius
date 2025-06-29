# frozen_string_literal: true

class RuntimeFunctionDefinitionPolicy < BasePolicy
  delegate { subject.runtime }
end
