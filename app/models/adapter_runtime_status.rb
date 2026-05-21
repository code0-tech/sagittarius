# frozen_string_literal: true

class AdapterRuntimeStatus < ApplicationRecord
  include RuntimeStatusFields

  has_many :adapter_status_configurations, inverse_of: :adapter_runtime_status, dependent: :destroy

  def configurations
    adapter_status_configurations
  end
end
