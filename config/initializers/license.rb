# frozen_string_literal: true

Rails.application.config.to_prepare do
  # public_key_file = File.read(Rails.root.join('config/license_key.pub'))
  # public_key = OpenSSL::PKey::RSA.new(public_key_file)
  #
  # Code0::License.encryption_key = public_key

  private_key_file = Rails.root.join('config/license_key.key').read
  private_key = OpenSSL::PKey::RSA.new(private_key_file)

  Code0::License.encryption_key = private_key
end
