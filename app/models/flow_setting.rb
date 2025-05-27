# frozen_string_literal: true

class FlowSetting < ApplicationRecord
  belongs_to :flow, optional: true
  belongs_to :definition, class_name: 'FlowSettingDefinition'

  def to_grpc
    Tucana::Shared::FlowSetting.new(
      definition: definition.to_grpc,
      object: Tucana::Shared::Struct.from_ruby(object)
    )
  end
end
