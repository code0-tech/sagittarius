---
title: namespacesProjectsFlowsUpdate
---

Update an existing flow.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `flowId` | [`FlowID!`](../scalar/flowid.md) | The ID of the flow to update |
| `flowInput` | [`FlowInput!`](../input_object/flowinput.md) | The updated flow |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `flow` | [`Flow`](../object/flow.md) | The updated flow. |
