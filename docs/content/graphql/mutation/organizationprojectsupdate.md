---
title: organizationProjectsUpdate
---

Updates a organization project.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `description` | [`String`](../scalar/string.md) | Description for the updated organization project. |
| `name` | [`String`](../scalar/string.md) | Name for the updated organization project. |
| `organizationProjectId` | [`OrganizationProjectID!`](../scalar/organizationprojectid.md) | The id of the organization project which will be updated |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationProject` | [`OrganizationProject`](../object/organizationproject.md) | The updated project. |