---
title: usersCreate
---

Admin-create a user.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `admin` | [`Boolean`](../scalar/boolean.md) | Admin status for the user. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `email` | [`String!`](../scalar/string.md) | Email for the user. |
| `firstname` | [`String`](../scalar/string.md) | Firstname for the user. |
| `lastname` | [`String`](../scalar/string.md) | Lastname for the user. |
| `password` | [`String!`](../scalar/string.md) | Password for the user. |
| `passwordRepeat` | [`String!`](../scalar/string.md) | Password repeat for the user to check for typos. |
| `username` | [`String!`](../scalar/string.md) | Username for the user. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The created user. |
