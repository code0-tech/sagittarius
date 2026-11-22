# frozen_string_literal: true

module StorageObjects
  # Reaps storage objects that should no longer exist (see FILE_STORAGE_CONCEPT.md §7):
  #   * pending uploads that were never finalized within StorageObject::PENDING_TTL
  #   * committed objects whose expires_at has passed
  # Blobs are purged alongside the record so storage does not grow unbounded.
  class CleanupJob < ApplicationJob
    def perform
      StorageObject.stale_pending.or(StorageObject.expired).find_each do |storage_object|
        storage_object.blob.purge if storage_object.blob.attached?
        storage_object.destroy!
      end
    end
  end
end
