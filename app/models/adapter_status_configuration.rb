# frozen_string_literal: true

class AdapterStatusConfiguration < ApplicationRecord
  belongs_to :adapter_runtime_status, inverse_of: :adapter_status_configurations
end
