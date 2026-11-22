# frozen_string_literal: true

module Types
  class StorageObjectType < Types::BaseObject
    description 'A project-owned stored file (the FILE data type)'

    authorize :read_storage_object

    field :byte_size, Types::BigIntType, null: false, description: 'Size of the file in bytes'
    field :checksum, String, null: true, description: 'Content checksum (sha256:...)'
    field :content_type, String, null: false, description: 'MIME type of the file'
    field :expires_at, Types::TimeType, null: true, description: 'When the file is scheduled to expire, if ever'
    field :file_name, String, null: false, description: 'Original file name'
    field :namespace, Types::NamespaceType, null: false, description: 'The namespace that owns the file'
    field :origin, String, null: false, description: 'How the file was created (user_upload, execution_output)'
    field :project, Types::NamespaceProjectType, null: false, description: 'The project that owns the file'
    field :status, String, null: false, description: 'pending or committed'

    field :download_url, String, null: true,
                                 description: 'Short-lived signed absolute URL to fetch the file bytes'

    expose_abilities %i[delete_storage_object]

    id_field StorageObject
    timestamps

    def download_url
      return nil unless object.status_committed? && object.blob.attached?

      StorageObjects::SignedUrl.download_url(StorageObjects::SignedUrl.encode_download(object).token)
    end
  end
end
