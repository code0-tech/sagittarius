---
title: organizationsUpdate
---

Update an existing organization.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `name` | [`String!`](../scalar/string.md) | Name for the new organization. |
| `organizationId` | [`OrganizationID!`](../scalar/organizationid.md) | ID of the organization to update. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organization` | [`Organization`](../object/organization.md) | The updated organization. |
