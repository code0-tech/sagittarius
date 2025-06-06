# frozen_string_literal: true

class CreateGenericCombinationStrategies < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :generic_combination_strategies do |t|
      t.integer :type, null: false
      t.references :generic_mapper, null: true, foreign_key: {
        to_table: :generic_mappers,
        on_delete: :cascade,
      }
      t.references :function_generic_mapper, null: true, foreign_key: {
        to_table: :function_generic_mappers,
        on_delete: :cascade,
      }

      t.timestamps_with_timezone
    end
  end
end
