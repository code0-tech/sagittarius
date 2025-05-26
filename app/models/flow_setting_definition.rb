# frozen_string_literal: true

class FlowSettingDefinition < ApplicationRecord
  has_many :flow_settings, inverse_of: :definition
end
