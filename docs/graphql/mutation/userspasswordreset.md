---
title: usersPasswordReset
---

Reset the password using a reset token

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `newPassword` | [`String!`](../scalar/string.md) | The new password to set for the user |
| `newPasswordConfirmation` | [`String!`](../scalar/string.md) | The confirmation of the new password to set for the user needs to be the same as the new password |
| `resetToken` | [`String!`](../scalar/string.md) | The password reset token sent to the user email |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `message` | [`String`](../scalar/string.md) | A message indicating the result of the password reset request |
