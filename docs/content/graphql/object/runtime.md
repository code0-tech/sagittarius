---
title: Runtime
---

Represents a runtime

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Runtime was created |
| `description` | [`String!`](../scalar/string.md) | The description for the runtime if present |
| `id` | [`RuntimeID!`](../scalar/runtimeid.md) | Global ID of this Runtime |
| `name` | [`String!`](../scalar/string.md) | The name for the runtime |
| `namespace` | [`Namespace`](../object/namespace.md) | The parent namespace for the runtime |
| `token` | [`String`](../scalar/string.md) | Token belonging to the runtime, only present on creation |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Runtime was last updated |

