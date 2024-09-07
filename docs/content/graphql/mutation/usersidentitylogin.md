---
title: usersIdentityLogin
---

Login to an existing user via an external identity

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
| `userSession` | [`UserSession`](../object/usersession.md) | The created user session |
