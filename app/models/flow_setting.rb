# frozen_string_literal: true

class FlowSetting < ApplicationRecord
  belongs_to :flow, optional: true
  belongs_to :definition, class_name: 'FlowSettingDefinition'
end
