# frozen_string_literal: true

class ErrorCode
  InvalidErrorCode = Class.new(StandardError)

  def self.validate_error_code!(error_code)
    return unless error_code.is_a?(Symbol)
    return if Rails.env.production?

    raise InvalidErrorCode, error_code unless error_codes.include?(error_code)
  end

  def self.error_codes
    {
      missing_permission: { description: 'The user is not permitted to perform this operation' },
      missing_parameter: { description: 'Not all required parameters are present' },
      cannot_remove_last_administrator: { description: 'This action would remove the last administrator' },
      cannot_remove_last_admin_ability: { description: 'This action would remove the last administrative ability' },
      cannot_delete_last_admin_role: { description: 'This action would remove the last administrative role' },
      inconsistent_namespace: { description: 'Resources are from different namespaces' },
      runtime_mismatch: { description: 'Resources are from different runtimes' },
      generic_key_not_found: { description: 'The given key was not found in the data type' },
      no_primary_runtime: { description: 'The project does not have a primary runtime' },
      invalid_external_identity: { description: 'This external identity is invalid' },
      external_identity_does_not_exist: { description: 'This external identity does not exist' },
      identity_validation_failed: { description: 'Failed to validate the external identity' },
      missing_identity_data: { description: 'This external identity is missing data' },
      registration_disabled: { description: 'Self-registration is disabled' },
      mfa_failed: { description: 'Invalid MFA data provided' },
      mfa_required: { description: 'MFA is required' },
      invalid_login_data: { description: 'Invalid login data provided' },
      totp_secret_already_set: { description: 'This user already has TOTP set up' },
      invalid_totp_secret: { description: 'The TOTP secret is invalid or cannot be verified' },
      wrong_totp: { description: 'Invalid TOTP code provided' },
      invalid_verification_code: { description: 'Invalid verification code provided' },
      unmodifiable_field: { description: 'The user is not permitted to modify this field' },
      failed_to_invalidate_old_backup_codes: { description: 'The old backup codes could not be deleted' },
      failed_to_save_valid_backup_code: { description: 'The new backup codes could not be saved' },
      invalid_setting: { description: 'Invalid setting provided' },
      invalid_user: { description: 'The user is invalid because of active model errors' },
      invalid_password_repeat: { description: 'The provided password repeat does not match the password' },
      cannot_modify_admin: { description: 'Only administrators can modify admin status of users' },
      cannot_modify_own_admin: { description: 'Users cannot modify their own admin status' },
      user_not_found: { description: 'The user with the given identifier was not found' },
      invalid_user_identity: { description: 'The user identity is invalid because of active model errors' },
      invalid_user_session: { description: 'The user session is invalid because of active model errors' },
      invalid_runtime: { description: 'The runtime is invalid because of active model errors' },
      invalid_organization: { description: 'The organization is invalid because of active model errors' },
      invalid_namespace_role: { description: 'The namespace role is invalid because of active model errors' },
      invalid_namespace_project: { description: 'The namespace project is invalid because of active model errors' },
      flow_validation_failed: { description: 'The flow validation has failed' },
      failed_to_reset_password: { description: 'Failed to reset the user password' },
      loading_identity_failed: { description: 'Failed to load user identity from external provider' },
      invalid_flow_setting: { description: 'The flow setting is invalid because of active model errors' },
      invalid_namespace_member: { description: 'The flow setting is invalid because of active model errors' },
      invalid_attachment: { description: 'The attachment is invalid because of active model errors' },
      invalid_namespace_license: { description: 'The namespace license is invalid because of active model errors' },
      project_not_found: { description: 'The namespace project with the given identifier was not found' },
      runtime_not_found: { description: 'The runtime with the given identifier was not found' },
      namespace_not_found: { description: 'The namespace with the given identifier was not found' },
      flow_not_found: { description: 'The flow with the given identifier was not found' },
      namespace_role_not_found: { description: 'The namespace role with the given identifier was not found' },
      identity_not_found: { description: 'The external identity with the given identifier was not found' },
      user_session_not_found: { description: 'The user session with the given identifier was not found' },
      namespace_project_not_found: { description: 'The namespace project with the given identifier was not found' },
      namespace_member_not_found: { description: 'The namespace member with the given identifier was not found' },
      license_not_found: { description: 'The namespace license with the given identifier was not found' },
      flow_type_not_found: { description: 'The flow type with the given identifier was not found' },
      organization_not_found: { description: 'The organization with the given identifier was not found' },
      primary_level_not_found: { description: '', deprecation_reason: 'Outdated concept' },
      secondary_level_not_found: { description: '', deprecation_reason: 'Outdated concept' },
      tertiary_level_exceeds_parameters: { description: '', deprecation_reason: 'Outdated concept' },
    }
  end
end

ErrorCode.prepend_extensions
