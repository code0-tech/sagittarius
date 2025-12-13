# frozen_string_literal: true

class NodeFunctionPolicy < BasePolicy
  delegate { subject.flow }
end
