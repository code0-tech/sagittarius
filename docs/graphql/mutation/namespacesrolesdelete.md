---
title: namespacesRolesDelete
---

Delete an existing role in a namespace.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceRoleId` | [`NamespaceRoleID!`](../scalar/namespaceroleid.md) | The id of the namespace role which will be deleted |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceRole` | [`NamespaceRole`](../object/namespacerole.md) | The deleted namespace role |
