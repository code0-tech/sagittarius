---
title: namespaceRolesAssignProjects
---

Update the project a role is assigned to.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `projectIds` | [`[NamespaceProjectID!]!`](../scalar/namespaceprojectid.md) | The projects that should be assigned to the role |
| `roleId` | [`NamespaceRoleID!`](../scalar/namespaceroleid.md) | The id of the role which should be assigned to projects |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `projects` | [`[NamespaceProject!]`](../object/namespaceproject.md) | The now assigned projects |
