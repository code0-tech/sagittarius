---
title: ExecutionResultNodeResult
---

Represents a node result of an execution result

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionResultNodeResult was created |
| `error` | [`ExecutionError`](../object/executionerror.md) | Error returned by this node execution |
| `finishedAt` | [`Time!`](../scalar/time.md) | Time when this node execution finished |
| `id` | [`ExecutionResultNodeResultID!`](../scalar/executionresultnoderesultid.md) | Global ID of this ExecutionResultNodeResult |
| `nodeFunction` | [`NodeFunction`](../object/nodefunction.md) | Node function associated with this result |
| `parameterResults` | [`[ExecutionResultParameterResult!]!`](../object/executionresultparameterresult.md) | Parameter results produced by this node execution |
| `position` | [`Int!`](../scalar/int.md) | Position of this node result in the execution result |
| `startedAt` | [`Time!`](../scalar/time.md) | Time when this node execution started |
| `success` | [`JSON`](../scalar/json.md) | Successful value returned by this node execution |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionResultNodeResult was last updated |
