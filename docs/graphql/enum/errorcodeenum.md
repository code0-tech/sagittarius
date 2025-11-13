---
title: ErrorCodeEnum
---

Represents the available error responses

| Value | Description |
|-------|-------------|
| `CANNOT_DELETE_LAST_ADMIN_ROLE` | This action would remove the last administrative role |
| `CANNOT_MODIFY_ADMIN` | Only administrators can modify admin status of users |
| `CANNOT_MODIFY_OWN_ADMIN` | Users cannot modify their own admin status |
| `CANNOT_REMOVE_LAST_ADMINISTRATOR` | This action would remove the last administrator |
| `CANNOT_REMOVE_LAST_ADMIN_ABILITY` | This action would remove the last administrative ability |
| `EXTERNAL_IDENTITY_DOES_NOT_EXIST` | This external identity does not exist |
| `FAILED_TO_INVALIDATE_OLD_BACKUP_CODES` | The old backup codes could not be deleted |
| `FAILED_TO_RESET_PASSWORD` | Failed to reset the user password |
| `FAILED_TO_SAVE_VALID_BACKUP_CODE` | The new backup codes could not be saved |
| `FLOW_NOT_FOUND` | The flow with the given identifier was not found |
| `FLOW_TYPE_NOT_FOUND` | The flow type with the given identifier was not found |
| `FLOW_VALIDATION_FAILED` | The flow validation has failed |
| `GENERIC_KEY_NOT_FOUND` | The given key was not found in the data type |
| `IDENTITY_NOT_FOUND` | The external identity with the given identifier was not found |
| `IDENTITY_VALIDATION_FAILED` | Failed to validate the external identity |
| `INCONSISTENT_NAMESPACE` | Resources are from different namespaces |
| `INVALID_ATTACHMENT` | The attachment is invalid because of active model errors |
| `INVALID_EXTERNAL_IDENTITY` | This external identity is invalid |
| `INVALID_FLOW_SETTING` | The flow setting is invalid because of active model errors |
| `INVALID_LOGIN_DATA` | Invalid login data provided |
| `INVALID_NAMESPACE_LICENSE` | The namespace license is invalid because of active model errors |
| `INVALID_NAMESPACE_MEMBER` | The flow setting is invalid because of active model errors |
| `INVALID_NAMESPACE_PROJECT` | The namespace project is invalid because of active model errors |
| `INVALID_NAMESPACE_ROLE` | The namespace role is invalid because of active model errors |
| `INVALID_ORGANIZATION` | The organization is invalid because of active model errors |
| `INVALID_PASSWORD_REPEAT` | The provided password repeat does not match the password |
| `INVALID_RUNTIME` | The runtime is invalid because of active model errors |
| `INVALID_SETTING` | Invalid setting provided |
| `INVALID_TOTP_SECRET` | The TOTP secret is invalid or cannot be verified |
| `INVALID_USER` | The user is invalid because of active model errors |
| `INVALID_USER_IDENTITY` | The user identity is invalid because of active model errors |
| `INVALID_USER_SESSION` | The user session is invalid because of active model errors |
| `INVALID_VERIFICATION_CODE` | Invalid verification code provided |
| `LICENSE_NOT_FOUND` | The namespace license with the given identifier was not found |
| `LOADING_IDENTITY_FAILED` | Failed to load user identity from external provider |
| `MFA_FAILED` | Invalid MFA data provided |
| `MFA_REQUIRED` | MFA is required |
| `MISSING_IDENTITY_DATA` | This external identity is missing data |
| `MISSING_PARAMETER` | Not all required parameters are present |
| `MISSING_PERMISSION` | The user is not permitted to perform this operation |
| `NAMESPACE_MEMBER_NOT_FOUND` | The namespace member with the given identifier was not found |
| `NAMESPACE_NOT_FOUND` | The namespace with the given identifier was not found |
| `NAMESPACE_PROJECT_NOT_FOUND` | The namespace project with the given identifier was not found |
| `NAMESPACE_ROLE_NOT_FOUND` | The namespace role with the given identifier was not found |
| `NO_FREE_LICENSE_SEATS` | There are no free license seats to complete this operation |
| `NO_PRIMARY_RUNTIME` | The project does not have a primary runtime |
| `PRIMARY_LEVEL_NOT_FOUND` | **Deprecated:** Outdated concept |
| `PROJECT_NOT_FOUND` | The namespace project with the given identifier was not found |
| `REGISTRATION_DISABLED` | Self-registration is disabled |
| `RUNTIME_MISMATCH` | Resources are from different runtimes |
| `RUNTIME_NOT_FOUND` | The runtime with the given identifier was not found |
| `SECONDARY_LEVEL_NOT_FOUND` | **Deprecated:** Outdated concept |
| `TERTIARY_LEVEL_EXCEEDS_PARAMETERS` | **Deprecated:** Outdated concept |
| `TOTP_SECRET_ALREADY_SET` | This user already has TOTP set up |
| `UNMODIFIABLE_FIELD` | The user is not permitted to modify this field |
| `USER_NOT_FOUND` | The user with the given identifier was not found |
| `USER_SESSION_NOT_FOUND` | The user session with the given identifier was not found |
| `WRONG_TOTP` | Invalid TOTP code provided |
