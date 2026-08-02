# frozen_string_literal: true

class IncreaseDataTypeIdentifierLimit < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_check_constraint :data_types, 'char_length(identifier) <= 50', name: 'check_3a7198812e'

    add_check_constraint :data_types, 'char_length(identifier) <= 200', name: 'check_3a7198812e'
  end
end
