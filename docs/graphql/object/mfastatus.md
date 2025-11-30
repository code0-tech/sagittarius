---
title: MfaStatus
---

Represents the MFA status of a user

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `backupCodesCount` | [`Int!`](../scalar/int.md) | The number of backup codes remaining for the user. |
| `enabled` | [`Boolean!`](../scalar/boolean.md) | Indicates whether MFA is enabled for the user. |
| `totpEnabled` | [`Boolean!`](../scalar/boolean.md) | Indicates whether TOTP MFA is enabled for the user. |

