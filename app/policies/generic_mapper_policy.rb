# frozen_string_literal: true

class GenericMapperPolicy < BasePolicy
  delegate { subject.generic_type }
end
