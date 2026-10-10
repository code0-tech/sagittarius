---
title: usersSetActiveSubscription
---

(Cloud only) Set or unset the active subscription status for a user. Used by Crater.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `active` | [`Boolean!`](../scalar/boolean.md) | Whether the user has an active subscription. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `userId` | [`UserID!`](../scalar/userid.md) | ID of the user to update. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The updated user. |
