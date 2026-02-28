---
title: Runtime
---

Represents a runtime

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Runtime was created |
| `dataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | DataTypes of the runtime |
| `description` | [`String!`](../scalar/string.md) | The description for the runtime if present |
| `flowTypes` | [`FlowTypeConnection!`](../object/flowtypeconnection.md) | FlowTypes of the runtime |
| `functionDefinitions` | [`FunctionDefinitionConnection!`](../object/functiondefinitionconnection.md) | Function definitions of the runtime |
| `id` | [`RuntimeID!`](../scalar/runtimeid.md) | Global ID of this Runtime |
| `name` | [`String!`](../scalar/string.md) | The name for the runtime |
| `namespace` | [`Namespace`](../object/namespace.md) | The parent namespace for the runtime |
| `projects` | [`NamespaceProjectConnection!`](../object/namespaceprojectconnection.md) | Projects associated with the runtime |
| `status` | [`RuntimeStatus!`](../object/runtimestatus.md) | The status of the runtime |
| `statuses` | [`RuntimeStatusConnection!`](../object/runtimestatusconnection.md) | Statuses of the runtime |
| `token` | [`String`](../scalar/string.md) | Token belonging to the runtime, only present on creation |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Runtime was last updated |
| `userAbilities` | [`RuntimeUserAbilities!`](../object/runtimeuserabilities.md) | Abilities for the current user on this Runtime |

