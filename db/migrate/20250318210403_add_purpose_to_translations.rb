# frozen_string_literal: true

class AddPurposeToTranslations < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :translations, :purpose, :text
  end
end
