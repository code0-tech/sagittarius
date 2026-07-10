# frozen_string_literal: true

class IncreaseTypeLimitsForDataTypesTo64kb < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_check_constraint :data_types, 'char_length(type) <= 8192', name: 'check_01ca31b7b9'

    add_check_constraint :data_types, 'char_length(type) <= 65536', name: 'check_01ca31b7b9'
  end
end
