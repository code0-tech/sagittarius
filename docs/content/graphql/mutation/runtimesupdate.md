---
title: runtimesUpdate
---

Update an existing runtime.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `description` | [`String`](../scalar/string.md) | Description for the new runtime. |
| `name` | [`String`](../scalar/string.md) | Name for the new runtime. |
| `runtimeId` | [`RuntimeID!`](../scalar/runtimeid.md) | ID of the runtime to update. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `runtime` | [`Runtime`](../object/runtime.md) | The updated runtime. |
