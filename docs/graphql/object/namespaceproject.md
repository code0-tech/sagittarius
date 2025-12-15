---
title: NamespaceProject
---

Represents a namespace project

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceProject was created |
| `description` | [`String!`](../scalar/string.md) | Description of the project |
| `flows` | [`FlowConnection`](../object/flowconnection.md) | Fetches all flows in this project |
| `id` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | Global ID of this NamespaceProject |
| `name` | [`String!`](../scalar/string.md) | Name of the project |
| `namespace` | [`Namespace!`](../object/namespace.md) | The namespace where this project belongs to |
| `primaryRuntime` | [`Runtime`](../object/runtime.md) | The primary runtime for the project |
| `roles` | [`NamespaceRoleConnection!`](../object/namespaceroleconnection.md) | Roles assigned to this project |
| `runtimes` | [`RuntimeConnection!`](../object/runtimeconnection.md) | Runtimes assigned to this project |
| `slug` | [`String!`](../scalar/string.md) | Slug of the project used in URLs to identify flows |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceProject was last updated |
| `userAbilities` | [`NamespaceProjectUserAbilities!`](../object/namespaceprojectuserabilities.md) | Abilities for the current user on this NamespaceProject |

## Fields with arguments

### flow

Fetches an flow given by its ID

Returns [`Flow`](../object/flow.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`FlowID!`](../scalar/flowid.md) | Id of the flow |
