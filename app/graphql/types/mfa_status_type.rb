# frozen_string_literal: true

module Types
  class MfaStatusType < Types::BaseObject
    description 'Represents the MFA status of a user'

    authorize :read_mfa_status

    field :enabled, Boolean, null: false,
                             description: 'Indicates whether MFA is enabled for the user.'

    field :totp_enabled, Boolean, null: false,
                                  description: 'Indicates whether TOTP MFA is enabled for the user.'

    field :backup_codes_count, Integer, null: false,
                                        description: 'The number of backup codes remaining for the user.'
  end
end
