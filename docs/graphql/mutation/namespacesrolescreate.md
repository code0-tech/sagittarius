---
title: namespacesRolesCreate
---

Create a new role in a namespace.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `name` | [`String!`](../scalar/string.md) | The name for the new role |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | The id of the namespace which this role will belong to |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceRole` | [`NamespaceRole`](../object/namespacerole.md) | The newly created namespace role |
