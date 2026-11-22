# frozen_string_literal: true

module StorageObjects
  # Mints and verifies the short-lived signed tokens that authorize a byte transfer. Issuing a token is
  # the point at which the durable project authorization is enforced; the token itself is a narrow
  # bearer capability bounded by its TTL and bound to exactly one storage object.
  #
  # Two purposes exist and a token of one never verifies as the other:
  # - upload:   a single PUT of the raw content into one pending object
  # - download: a GET of the content of one committed object
  module SignedUrl
    UPLOAD_TTL = 15.minutes
    DOWNLOAD_TTL = 5.minutes
    UPLOAD_PURPOSE = :storage_object_upload
    DOWNLOAD_PURPOSE = :storage_object_download

    Token = Struct.new(:token, :expires_at)

    module_function

    def verifier
      Rails.application.message_verifier('storage_object:download')
    end

    def encode_upload(storage_object, ttl: UPLOAD_TTL)
      encode(storage_object, UPLOAD_PURPOSE, ttl)
    end

    def encode_download(storage_object, ttl: DOWNLOAD_TTL)
      encode(storage_object, DOWNLOAD_PURPOSE, ttl)
    end

    # Absolute URL (see Sagittarius::Configuration.file_storage_external_url) accepting a PUT.
    def upload_url(token)
      "#{Sagittarius::Configuration.file_storage_external_url}/storage_objects/upload?#{{ signature: token }.to_query}"
    end

    # Absolute URL (see Sagittarius::Configuration.file_storage_external_url) serving a GET.
    def download_url(token)
      "#{Sagittarius::Configuration.file_storage_external_url}/storage_objects/download?" \
        "#{{ signature: token }.to_query}"
    end

    # Returns the PENDING StorageObject an upload token points at, or nil when the token is missing,
    # tampered with, expired or of the wrong purpose, or the object is gone or no longer pending.
    def decode_upload(token)
      decode(token, UPLOAD_PURPOSE)&.status_pending&.first
    end

    # Returns the COMMITTED StorageObject a download token points at, or nil (see decode_upload).
    def decode_download(token)
      decode(token, DOWNLOAD_PURPOSE)&.status_committed&.first
    end

    def encode(storage_object, purpose, ttl)
      expires_at = ttl.from_now
      token = verifier.generate({ id: storage_object.id }, expires_at: expires_at, purpose: purpose)
      Token.new(token, expires_at)
    end

    # Relation of the object the token names, or nil when the token is not valid for the purpose.
    def decode(token, purpose)
      return nil unless token.is_a?(String) && token.present?

      data = verifier.verify(token, purpose: purpose)
      StorageObject.where(id: data['id'] || data[:id])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end
  end
end
