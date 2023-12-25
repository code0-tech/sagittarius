---
title: usersRegister
---

Register a new user

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `email` | [`String!`](../scalar/string.md) | Email of the user |
| `password` | [`String!`](../scalar/string.md) | Password of the user |
| `username` | [`String!`](../scalar/string.md) | Username of the user |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The created user |
