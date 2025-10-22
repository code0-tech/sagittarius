---
title: namespacesLicensesCreate
---

(EE only) Create a new namespace license.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `data` | [`String!`](../scalar/string.md) | The license data. |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | The namespace ID. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `namespaceLicense` | [`NamespaceLicense`](../object/namespacelicense.md) | The newly created license. |
