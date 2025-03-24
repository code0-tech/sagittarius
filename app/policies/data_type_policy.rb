# frozen_string_literal: true

class DataTypePolicy < BasePolicy
  delegate { subject.runtime || :global }
end
