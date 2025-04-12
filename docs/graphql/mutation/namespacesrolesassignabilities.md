---
title: namespacesRolesAssignAbilities
---

Update the abilities a role is granted.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[NamespaceRoleAbility!]!`](../enum/namespaceroleability.md) | The abilities that should be granted to the ability |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `roleId` | [`NamespaceRoleID!`](../scalar/namespaceroleid.md) | The id of the role which should be granted the abilities |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[NamespaceRoleAbility!]`](../enum/namespaceroleability.md) | The now granted abilities |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
