---
title: usersLogin
---

Login to an existing user

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `email` | [`String`](../scalar/string.md) | Email of the user |
| `mfa` | [`MfaInput`](../input_object/mfainput.md) | The data of the mfa login |
| `password` | [`String!`](../scalar/string.md) | Password of the user |
| `username` | [`String`](../scalar/string.md) | Username of the user |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `userSession` | [`UserSession`](../object/usersession.md) | The created user session |
