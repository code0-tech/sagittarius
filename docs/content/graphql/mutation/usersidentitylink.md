---
title: usersIdentityLink
---

Links an external identity to and existing user

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `args` | [`IdentityInput!`](../input_object/identityinput.md) | The validation object |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `providerId` | [`String!`](../scalar/string.md) | The ID of the external provider (e.g. google, discord, gitlab...)  |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `userIdentity` | [`UserIdentity`](../object/useridentity.md) | The created user session |
