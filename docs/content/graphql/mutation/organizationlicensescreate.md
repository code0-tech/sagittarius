---
title: organizationLicensesCreate
---

Create a new organization license.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `data` | [`String!`](../scalar/string.md) | The license data. |
| `organizationId` | [`OrganizationID!`](../scalar/organizationid.md) | The organization ID. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationLicense` | [`OrganizationLicense`](../object/organizationlicense.md) | The newly created license. |
