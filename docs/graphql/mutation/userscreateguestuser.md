---
title: usersCreateGuestUser
---

(Cloud only) Create a guest user account. Callable by Crater.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `email` | [`String!`](../scalar/string.md) | Email for the guest user. |
| `username` | [`String!`](../scalar/string.md) | Username for the guest user. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `claimToken` | [`String`](../scalar/string.md) | Token the guest uses to complete their profile. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The created guest user. |
