# frozen_string_literal: true

class NodeFunctionPolicy < BasePolicy
  delegate { subject.runtime_function }
end
