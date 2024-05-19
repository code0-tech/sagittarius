---
title: organizationLicensesDelete
---

Deletes an organization license.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `organizationId` | [`OrganizationID!`](../scalar/organizationid.md) | The organization ID. |
| `organizationLicenseId` | [`OrganizationLicenseID!`](../scalar/organizationlicenseid.md) | The license id to delete. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationLicense` | [`OrganizationLicense`](../object/organizationlicense.md) | The deleted organization license. |
