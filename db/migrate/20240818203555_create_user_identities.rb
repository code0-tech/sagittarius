# frozen_string_literal: true

class CreateUserIdentities < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :user_identities do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.text :provider_id, null: false
      t.text :identifier, null: false

      t.index %i[provider_id identifier], unique: true
      t.index %i[user_id provider_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
