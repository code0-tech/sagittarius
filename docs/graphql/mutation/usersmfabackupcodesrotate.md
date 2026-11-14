---
title: usersMfaBackupCodesRotate
---

Rotates the backup codes of a user.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `mfa` | [`MfaInput`](../input_object/mfainput.md) | The mfa validation data, required when MFA is enabled. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `codes` | [`[String!]`](../scalar/string.md) | The newly rotated backup codes. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
