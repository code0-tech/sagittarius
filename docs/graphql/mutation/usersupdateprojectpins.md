---
title: usersUpdateProjectPins
---

Updates the pinned projects for the current user within a namespace, in the given order

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | ID of the namespace to pin the projects to |
| `projectIds` | [`[NamespaceProjectID!]!`](../scalar/namespaceprojectid.md) | Ordered list of project IDs to pin for the user within the namespace |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The updated user |
