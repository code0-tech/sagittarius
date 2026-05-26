# frozen_string_literal: true

class SubFlowSetting < ApplicationRecord
  belongs_to :sub_flow, inverse_of: :sub_flow_settings

  validates :identifier, presence: true

  def to_grpc
    Tucana::Shared::SubFlowSetting.new(
      identifier: identifier,
      default_value: Tucana::Shared::Value.from_ruby(default_value),
      optional: optional,
      hidden: hidden
    )
  end
end
