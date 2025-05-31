# frozen_string_literal: true

class NodeFunctionPolicy < BasePolicy
  delegate { subject.resolve_flow }
end
