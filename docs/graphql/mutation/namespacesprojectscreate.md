---
title: namespacesProjectsCreate
---

Creates a new namespace project.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `description` | [`String`](../scalar/string.md) | Description for the new project. |
| `name` | [`String!`](../scalar/string.md) | Name for the new project. |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | The id of the namespace which this project will belong to |
| `slug` | [`String`](../scalar/string.md) | Slug for the new project. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceProject` | [`NamespaceProject`](../object/namespaceproject.md) | The newly created project. |
