---
title: storageObjectsDelete
---

Delete a stored file.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `id` | [`StorageObjectID!`](../scalar/storageobjectid.md) | GlobalID of the storage object to delete. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `storageObject` | [`StorageObject`](../object/storageobject.md) | The deleted storage object. |
