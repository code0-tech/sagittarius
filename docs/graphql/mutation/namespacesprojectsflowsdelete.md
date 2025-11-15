---
title: namespacesProjectsFlowsDelete
---

Deletes a namespace project.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `flowId` | [`FlowID!`](../scalar/flowid.md) | The id of the flow which will be deleted |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `flow` | [`Flow`](../object/flow.md) | The deleted flow. |
