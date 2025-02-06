---
title: User
---

Represents a user

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `admin` | [`Boolean!`](../scalar/boolean.md) | Global admin status of the user |
| `avatarUrl` | [`String`](../scalar/string.md) | The avatar if present of the user |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this User was created |
| `email` | [`String!`](../scalar/string.md) | Email of the user |
| `firstname` | [`String!`](../scalar/string.md) | Firstname of the user |
| `id` | [`UserID!`](../scalar/userid.md) | Global ID of this User |
| `lastname` | [`String!`](../scalar/string.md) | Lastname of the user |
| `namespace` | [`Namespace`](../object/namespace.md) | Namespace of this user |
| `namespaceMemberships` | [`NamespaceMemberConnection!`](../object/namespacememberconnection.md) | Namespace Memberships of this user |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this User was last updated |
| `username` | [`String!`](../scalar/string.md) | Username of the user |

