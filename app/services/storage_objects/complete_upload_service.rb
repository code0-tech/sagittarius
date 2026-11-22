# frozen_string_literal: true

module StorageObjects
  # Receives the bytes for a pending StorageObject, enforces the namespace size/quota limits and commits
  # it. The upload is authorized by the signed token that was issued for the object, so no further
  # authentication happens here. The object is locked and must still be pending, which makes an upload
  # URL single-use even under concurrent requests.
  class CompleteUploadService
    include Sagittarius::Database::Transactional

    attr_reader :storage_object, :io

    def initialize(storage_object, io:)
      @storage_object = storage_object
      @io = io
    end

    def execute
      transactional do |t|
        storage_object.with_lock do
          next not_found_response unless storage_object.status_pending?

          namespace = storage_object.project.namespace
          size = io.size
          if size > namespace.effective_max_file_size_bytes
            next ServiceResponse.error(message: 'File exceeds the maximum allowed size',
                                       error_code: :file_too_large)
          end

          # Known race: the quota is checked per object and not namespace-wide locked, so concurrent
          # uploads can overshoot it by at most their own sizes. Acceptable, as the quota is a soft limit
          # and uploads are bounded by the per-file maximum.
          if size > namespace.storage_available_bytes
            next ServiceResponse.error(message: 'Namespace storage quota exceeded', error_code: :quota_exceeded)
          end

          commit(size, t)
        end
      end
    end

    private

    def commit(size, transaction)
      storage_object.assign_attributes(status: :committed, byte_size: size, checksum: compute_checksum)

      unless storage_object.save
        transaction.rollback_and_return!(
          ServiceResponse.error(message: 'Storage object is invalid',
                                error_code: :invalid_storage_object, details: storage_object.errors)
        )
      end

      # The blob carries the name and type fixed when the upload was prepared, never request headers.
      storage_object.blob.attach(io: io, filename: storage_object.file_name,
                                 content_type: storage_object.content_type, identify: false)

      audit(size)

      ServiceResponse.success(message: 'Successfully stored', payload: storage_object)
    end

    def not_found_response
      ServiceResponse.error(message: 'Storage object not found', error_code: :storage_object_not_found)
    end

    # Runtime uploads have no user to attribute an audit event to (an event needs an author), so only
    # user uploads are audited.
    def audit(size)
      return if storage_object.created_by.nil?

      AuditService.audit(
        :storage_object_created,
        author_id: storage_object.created_by.id,
        entity: storage_object,
        details: { file_name: storage_object.file_name, byte_size: size },
        target: storage_object.project
      )
    end

    # Hash the upload ourselves so the stored checksum is content-addressable
    # (sha256) rather than ActiveStorage's internal MD5.
    def compute_checksum
      digest = Digest::SHA256.new
      io.rewind
      while (chunk = io.read(1.megabyte))
        digest.update(chunk)
      end
      io.rewind
      "sha256:#{digest.hexdigest}"
    end
  end
end
