# frozen_string_literal: true

# A project-owned blob reference, scoped exactly like a flow. The runtime's `FILE` value carries this
# object's database id as its handle instead of the file bytes themselves; the bytes live in
# ActiveStorage (local disk / S3 / ...) and are fetched lazily and authorized against the owning project.
# The project's namespace is the quota anchor. See FILE_STORAGE_CONCEPT.md.
class StorageObject < ApplicationRecord
  # pending objects whose upload never finalized are reaped after this long.
  PENDING_TTL = 24.hours

  belongs_to :project, class_name: 'NamespaceProject', inverse_of: :storage_objects
  belongs_to :created_by, class_name: 'User', optional: true, inverse_of: :storage_objects

  has_one_attached :blob

  # Prefixed because an unprefixed `committed` enum would generate `committed!`,
  # which collides with ActiveRecord's transaction callback of the same name.
  enum :status, { pending: 0, committed: 1 }, default: :pending, prefix: :status
  enum :origin, { user_upload: 0, execution_output: 1 }, default: :user_upload, prefix: :origin

  validates :file_name, presence: true, length: { maximum: 255 }
  validates :content_type, presence: true
  validates :byte_size, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Files live forever unless the uploader explicitly set `expires_at`.
  scope :expired, -> { where.not(expires_at: nil).where(expires_at: ..Time.current) }
  scope :stale_pending, -> { status_pending.where(created_at: ..PENDING_TTL.ago) }

  delegate :namespace, to: :project

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def to_grpc
    Tucana::Shared::FileMetadata.new(
      id: id,
      file_name: file_name,
      content_type: content_type,
      byte_size: byte_size,
      checksum: checksum.to_s,
      expires_at: expires_at && (expires_at.to_r * 1000).to_i
    )
  end
end
