# frozen_string_literal: true

Rails.application.config.to_prepare do
  if Rails.env.test?
    Code0::License.encryption_key = OpenSSL::PKey::RSA.generate(4096)
  else
    public_key_file = Rails.root.join('config', 'keys', "license_encryption_key_#{Rails.env}.pub").read
    public_key = OpenSSL::PKey::RSA.new(public_key_file)

    Code0::License.encryption_key = public_key
  end
end
