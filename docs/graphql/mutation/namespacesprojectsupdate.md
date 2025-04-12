---
title: namespacesProjectsUpdate
---

Updates a namespace project.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `description` | [`String`](../scalar/string.md) | Description for the updated project. |
| `name` | [`String`](../scalar/string.md) | Name for the updated project. |
| `namespaceProjectId` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | The id of the namespace project which will be updated |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `namespaceProject` | [`NamespaceProject`](../object/namespaceproject.md) | The updated project. |
