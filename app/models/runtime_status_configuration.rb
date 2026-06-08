# frozen_string_literal: true

class RuntimeStatusConfiguration < ApplicationRecord
  belongs_to :runtime_status

  validates :endpoint, presence: true,
                       allow_blank: false
end
