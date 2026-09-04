---
title: usersUpdateNamespacePins
---

Updates the pinned namespaces for the current user, in the given order

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceIds` | [`[NamespaceID!]!`](../scalar/namespaceid.md) | Ordered list of namespace IDs to pin for the user |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The updated user |
