# frozen_string_literal: true

class FlowSetting < ApplicationRecord
  belongs_to :flow, optional: true

  validates :flow_setting_id, presence: true

  def to_grpc
    Tucana::Shared::FlowSetting.new(
      database_id: id,
      flow_setting_id: flow_setting_id,
      value: Tucana::Shared::Value.from_ruby(object)
    )
  end
end
