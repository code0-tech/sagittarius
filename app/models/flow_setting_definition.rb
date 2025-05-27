# frozen_string_literal: true

class FlowSettingDefinition < ApplicationRecord
  has_many :flow_settings, inverse_of: :definition

  def to_grpc
    Tucana::Shared::FlowSettingDefinition.new(
      id: identifier,
      key: key
    )
  end
end
