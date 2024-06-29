---
title: runtimesCreate
---

Create a new runtime.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `description` | [`String`](../scalar/string.md) | The description for the new runtime. |
| `name` | [`String!`](../scalar/string.md) | Name for the new runtime. |
| `namespaceId` | [`NamespaceID`](../scalar/namespaceid.md) | The Parent Id for the runtime. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `runtime` | [`Runtime`](../object/runtime.md) | The newly created runtime. |
