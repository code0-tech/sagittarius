---
title: usersLogout
---

Logout an existing user session

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `userSessionId` | [`UserSessionID!`](../scalar/usersessionid.md) | ID of the session to logout |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `userSession` | [`UserSession`](../object/usersession.md) | The logged out user session |
