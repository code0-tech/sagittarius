# frozen_string_literal: true

class AddSlugToProjects < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # rubocop:disable Rails/NotNullColumn -- backwards compatibility intentionally ignored
    add_column :namespace_projects, :slug, :text, null: false, unique: true, limit: 50
    # rubocop:enable Rails/NotNullColumn
  end
end
