---
title: teamRolesCreate
---

Create a new role in an organization.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `name` | [`String!`](../scalar/string.md) | The name for the new role |
| `organizationId` | [`OrganizationID!`](../scalar/organizationid.md) | The id of the organization which this role will belong to |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationRole` | [`OrganizationRole`](../object/organizationrole.md) | The newly created organization role |
