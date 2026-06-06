---
title: ExecutionNodeResult
---

Represents a node result of an execution result

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionNodeResult was created |
| `error` | [`ExecutionError`](../object/executionerror.md) | Error returned by this node execution |
| `finishedAt` | [`BigInt!`](../scalar/bigint.md) | Unix epoch time in microseconds when this node execution finished |
| `id` | [`ExecutionNodeResultID!`](../scalar/executionnoderesultid.md) | Global ID of this ExecutionNodeResult |
| `nodeFunction` | [`NodeFunction`](../object/nodefunction.md) | Node function associated with this result |
| `parameterResults` | [`[ExecutionParameterResult!]!`](../object/executionparameterresult.md) | Parameter results produced by this node execution |
| `position` | [`Int!`](../scalar/int.md) | Position of this node result in the execution result |
| `startedAt` | [`BigInt!`](../scalar/bigint.md) | Unix epoch time in microseconds when this node execution started |
| `success` | [`JSON`](../scalar/json.md) | Successful value returned by this node execution |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionNodeResult was last updated |
