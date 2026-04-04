# frozen_string_literal: true

class AddInputTypeIdentifierToReferenceValue < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :reference_values, :input_type_identifier, :text
  end
end
