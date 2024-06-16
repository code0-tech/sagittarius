---
title: namespaceRolesUpdate
---

Update an existing namespace role.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `name` | [`String!`](../scalar/string.md) | Name for the namespace role. |
| `namespaceRoleId` | [`NamespaceRoleID!`](../scalar/namespaceroleid.md) | ID of the namespace role to update. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `namespaceRole` | [`NamespaceRole`](../object/namespacerole.md) | The updated namespace role. |
