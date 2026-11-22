# frozen_string_literal: true

class AddStorageQuotaToNamespaces < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # Both nullable: NULL means "fall back to the application default"
    # (see Namespace#effective_* helpers), so existing namespaces keep working.
    add_column :namespaces, :storage_quota_bytes, :bigint
    add_column :namespaces, :max_file_size_bytes, :bigint
  end
end
