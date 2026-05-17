---
title: licensesDelete
---

(EE only) Deletes an license.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `licenseId` | [`LicenseID!`](../scalar/licenseid.md) | The license id to delete. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `license` | [`License`](../object/license.md) | The deleted license. |
