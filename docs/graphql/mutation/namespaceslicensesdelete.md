---
title: namespacesLicensesDelete
---

Deletes an namespace license.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceLicenseId` | [`NamespaceLicenseID!`](../scalar/namespacelicenseid.md) | The license id to delete. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `namespaceLicense` | [`NamespaceLicense`](../object/namespacelicense.md) | The deleted namespace license. |
