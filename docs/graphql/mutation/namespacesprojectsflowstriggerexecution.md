---
title: namespacesProjectsFlowsTriggerExecution
---

Triggers a execution on the flow.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `flowId` | [`FlowID!`](../scalar/flowid.md) | The id of the flow which will be triggered |
| `input` | [`JSON!`](../scalar/json.md) | The input for the execution |
| `runtimeId` | [`RuntimeID!`](../scalar/runtimeid.md) | The id of the runtime to trigger the execution on |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `executionIdentifier` | [`String`](../scalar/string.md) | The execution identifier of the triggered execution. |
