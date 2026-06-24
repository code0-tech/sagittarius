# frozen_string_literal: true

class AllowNullValueInFlowSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    change_column_null :flow_settings, :object, true
  end
end
