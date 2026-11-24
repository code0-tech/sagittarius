---
title: namespacesProjectsFlowsExecution
---

Subscription to asynchronously receive an execution.

This subscription only notifies about new executions. The full execution result
details are available via the [`Flow.executionResult`](../object/flow.md#executionresult) query.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `flowId` | [`FlowID!`](../scalar/flowid.md) | Id of the flow to receive executions for |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `executionIdentifier` | [`String!`](../scalar/string.md) | The execution identifier of the new execution |
