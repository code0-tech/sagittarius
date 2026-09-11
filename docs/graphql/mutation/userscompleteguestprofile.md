---
title: usersCompleteGuestProfile
---

(Cloud only) Complete a guest profile with a claim token, promoting the guest to a regular user.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `claimToken` | [`String!`](../scalar/string.md) | The claim token received for the guest user. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
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
| `userSession` | [`UserSession`](../object/usersession.md) | The created user session. |
