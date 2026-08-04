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
| `modules` | [`RuntimeModuleConnection!`](../object/runtimemoduleconnection.md) | Modules of the runtime |
| `name` | [`String!`](../scalar/string.md) | The name for the runtime |
| `namespace` | [`Namespace`](../object/namespace.md) | The parent namespace for the runtime |
| `projects` | [`NamespaceProjectConnection!`](../object/namespaceprojectconnection.md) | Projects associated with the runtime |
| `status` | [`RuntimeStatus!`](../object/runtimestatus.md) | The status of the runtime |
| `token` | [`String`](../scalar/string.md) | Token belonging to the runtime, only present on creation |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Runtime was last updated |
| `userAbilities` | [`RuntimeUserAbilities!`](../object/runtimeuserabilities.md) | Abilities for the current user on this Runtime |
