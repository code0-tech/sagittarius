# frozen_string_literal: true

class CreateStorageObjects < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :storage_objects do |t|
      # Project-scoped like flows. The namespace (via the project) is only the quota anchor.
      # Rows are removed by the database together with their project; blobs are purged
      # explicitly beforehand (see Namespaces::Projects::DeleteService).
      t.references :project, null: false, foreign_key: { to_table: :namespace_projects, on_delete: :cascade },
                             index: false
      t.references :created_by, null: true, foreign_key: { to_table: :users }

      t.text :file_name, null: false
      t.text :content_type, null: false
      t.bigint :byte_size, null: false, default: 0
      t.text :checksum

      # Set for files a runtime produced during an execution, to trace them back to it.
      t.text :execution_identifier

      # pending = 0 (upload not finalized), committed = 1.
      t.integer :status, null: false, default: 0
      # user_upload = 0, execution_output = 1.
      t.integer :origin, null: false, default: 0

      t.datetime_with_timezone :expires_at

      t.timestamps_with_timezone

      t.check_constraint 'char_length(file_name) <= 255', name: 'storage_objects_file_name_length'
    end

    add_index :storage_objects, %i[project_id status]
    add_index :storage_objects, :expires_at, where: 'expires_at IS NOT NULL'
  end
end
