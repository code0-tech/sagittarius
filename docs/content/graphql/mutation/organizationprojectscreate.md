---
title: organizationProjectsCreate
---

Creates a new organization project.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `description` | [`String`](../scalar/string.md) | Description for the new organization project. |
| `name` | [`String!`](../scalar/string.md) | Name for the new organization project. |
| `organizationId` | [`OrganizationID!`](../scalar/organizationid.md) | The id of the organization which this project will belong to |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationProject` | [`OrganizationProject`](../object/organizationproject.md) | The newly created project. |
