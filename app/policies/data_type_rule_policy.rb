# frozen_string_literal: true

class DataTypeRulePolicy < BasePolicy
  delegate { subject.data_type }
end
