# frozen_string_literal: true

class AddUserTypeToUsers < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :users, :user_type, :integer, default: 0, null: false
  end
end
