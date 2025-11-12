---
title: usersUpdate
---

Update an existing user.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `admin` | [`Boolean`](../scalar/boolean.md) | New global admin status for the user. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `email` | [`String`](../scalar/string.md) | New email for the user. |
| `firstname` | [`String`](../scalar/string.md) | New firstname for the user. |
| `lastname` | [`String`](../scalar/string.md) | New lastname for the user. |
| `mfa` | [`MfaInput`](../input_object/mfainput.md) | The data of the mfa validation |
| `password` | [`String`](../scalar/string.md) | New password for the user. |
| `passwordRepeat` | [`String`](../scalar/string.md) | New password repeat for the user to check for typos, required if password is set. |
| `userId` | [`UserID!`](../scalar/userid.md) | ID of the user to update. |
| `username` | [`String`](../scalar/string.md) | New username for the user. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The updated user. |
