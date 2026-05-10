# frozen_string_literal: true

class AddReadmeToUser < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :users, :readme, :text, null: true, limit: 5000
  end
end
