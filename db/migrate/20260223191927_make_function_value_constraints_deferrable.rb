# frozen_string_literal: true

class MakeFunctionValueConstraintsDeferrable < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_foreign_key :node_parameters,
                       :node_functions,
                       column: :function_value_id,
                       on_delete: :restrict

    add_foreign_key :node_parameters,
                    :node_functions,
                    column: :function_value_id,
                    deferrable: :deferred
  end
end
