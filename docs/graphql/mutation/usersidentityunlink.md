---
title: usersIdentityUnlink
---

Unlinks an external identity from an user

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `identityId` | [`UserIdentityID!`](../scalar/useridentityid.md) | The ID of the identity to remove |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `userIdentity` | [`UserIdentity`](../object/useridentity.md) | The removed identity |
