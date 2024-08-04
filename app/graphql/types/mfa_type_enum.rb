# frozen_string_literal: true

module Types
  class MfaTypeEnum < BaseEnum
    description 'Represent all available types to authenticate with mfa'

    value :TOTP, 'Time based onetime password', value: :totp
    value :BACKUP_CODE, 'Single use backup code', value: :backup_code
  end
end
