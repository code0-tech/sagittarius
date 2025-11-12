---
title: namespacesProjectsAssignRuntimes
---

Assign runtimes to a project

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceProjectId` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | ID of the project to assign runtimes to |
| `runtimeIds` | [`[RuntimeID!]!`](../scalar/runtimeid.md) | The new runtimes assigned to the project |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceProject` | [`NamespaceProject`](../object/namespaceproject.md) | The updated project with assigned runtimes |
