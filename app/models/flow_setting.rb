# frozen_string_literal: true

class FlowSetting < ApplicationRecord
  belongs_to :flow, optional: true

  def to_grpc
    Tucana::Shared::FlowSetting.new(
      database_id: id,
      flow_setting_id: flow_setting_id,
      object: Tucana::Shared::Struct.from_ruby(object)
    )
  end
end
