# frozen_string_literal: true

class GenericTypePolicy < BasePolicy
  delegate { subject.data_type }
end
