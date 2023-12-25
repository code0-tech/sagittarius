---
title: UserSession
---

Represents a user session

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `active` | [`Boolean!`](../scalar/boolean.md) | Whether or not the session is active and can be used |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this UserSession was created |
| `id` | [`UserSessionID!`](../scalar/usersessionid.md) | GlobalID of the user |
| `token` | [`String`](../scalar/string.md) | Token belonging to the session, only present on creation |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this UserSession was last updated |
| `user` | [`User!`](../object/user.md) | User that belongs to the session |

