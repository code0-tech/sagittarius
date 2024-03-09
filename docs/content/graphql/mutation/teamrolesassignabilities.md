---
title: teamRolesAssignAbilities
---

Update the abilities a role is granted.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[OrganizationRoleAbility!]!`](../enum/organizationroleability.md) | The abilities that should be granted to the ability |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `roleId` | [`OrganizationRoleID!`](../scalar/organizationroleid.md) | The id of the role which should be granted the abilities |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[OrganizationRoleAbility!]`](../enum/organizationroleability.md) | The now granted abilities |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
