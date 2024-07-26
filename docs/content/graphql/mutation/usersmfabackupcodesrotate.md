---
title: usersMfaBackupCodesRotate
---

rotates the backup codes of a user.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `codes` | [`[String!]`](../scalar/string.md) | The newly rotated backup codes. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
