# frozen_string_literal: true

class RuntimeStatusConfiguration < ApplicationRecord
  belongs_to :runtime_status, inverse_of: :runtime_status_configurations

  validates :endpoint, presence: true,
                       allow_blank: false
end
