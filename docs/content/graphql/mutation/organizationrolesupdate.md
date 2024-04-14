---
title: organizationRolesUpdate
---

Update an existing organisation role.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `name` | [`String!`](../scalar/string.md) | Name for the new organization. |
| `organizationRoleId` | [`OrganizationRoleID!`](../scalar/organizationroleid.md) | ID of the organization role to update. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationRole` | [`OrganizationRole`](../object/organizationrole.md) | The updated organization role. |
