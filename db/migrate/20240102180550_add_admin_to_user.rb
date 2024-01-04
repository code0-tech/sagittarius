# frozen_string_literal: true

class AddAdminToUser < Sagittarius::Database::Migration[1.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
