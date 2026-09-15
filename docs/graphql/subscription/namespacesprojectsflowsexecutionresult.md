---
title: namespacesProjectsFlowsExecutionResult
---

Subscription to asynchronously receive an execution result

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `flowId` | [`FlowID!`](../scalar/flowid.md) | Id of the flow to receive execution results for |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `executionResult` | [`ExecutionResult`](../object/executionresult.md) | The most recent execution result of the relevant flow |
