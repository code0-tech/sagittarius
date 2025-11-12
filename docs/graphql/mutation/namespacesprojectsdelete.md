---
title: namespacesProjectsDelete
---

Deletes a namespace project.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceProjectId` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | The id of the namespace project which will be deleted |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceProject` | [`NamespaceProject`](../object/namespaceproject.md) | The deleted project. |
