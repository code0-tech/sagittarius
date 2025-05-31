# frozen_string_literal: true

class NodeParameterPolicy < BasePolicy
  delegate { subject.node_function }
end
