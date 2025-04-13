---
title: UserIdentity
---

Represents an external user identity

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this UserIdentity was created |
| `id` | [`UserIdentityID!`](../scalar/useridentityid.md) | Global ID of this UserIdentity |
| `identifier` | [`String!`](../scalar/string.md) | The description for the runtime if present |
| `providerId` | [`String!`](../scalar/string.md) | The name for the runtime |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this UserIdentity was last updated |
| `user` | [`User!`](../object/user.md) | The correlating user of the identity |

