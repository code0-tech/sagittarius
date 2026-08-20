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
| `runtimeAssignments` | [`NamespaceProjectRuntimeAssignmentConnection!`](../object/namespaceprojectruntimeassignmentconnection.md) | Runtime assignments of this project. |
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

### runtimeUsage

Execution usage of this project, bucketed by day, week or month

Returns [`[RuntimeUsageBucket!]!`](../object/runtimeusagebucket.md).

| Name | Type | Description |
|------|------|-------------|
| `afterDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | Start of the usage range (inclusive) |
| `aggregation` | [`RuntimeUsageAggregation`](../enum/runtimeusageaggregation.md) | Granularity to bucket usage into |
| `beforeDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | End of the usage range (inclusive) |
