# frozen_string_literal: true

class AddAdminToUser < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
