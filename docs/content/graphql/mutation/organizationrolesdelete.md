---
title: organizationRolesDelete
---

Delete an existing role in an organization.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `organizationRoleId` | [`OrganizationRoleID!`](../scalar/organizationroleid.md) | The id of the organization role which will be deleted |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationRole` | [`OrganizationRole`](../object/organizationrole.md) | The deleted organization role |
