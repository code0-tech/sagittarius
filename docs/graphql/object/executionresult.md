---
title: ExecutionResult
---

Represents an execution result

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionResult was created |
| `error` | [`ExecutionError`](../object/executionerror.md) | Error returned by the execution result |
| `finishedAt` | [`BigInt!`](../scalar/bigint.md) | Unix epoch time in microseconds when this execution result finished |
| `flow` | [`Flow!`](../object/flow.md) | Flow executed by this execution result |
| `id` | [`ExecutionResultID!`](../scalar/executionresultid.md) | Global ID of this ExecutionResult |
| `input` | [`JSON`](../scalar/json.md) | Input recorded in the execution result |
| `nodeResults` | [`ExecutionNodeResultConnection!`](../object/executionnoderesultconnection.md) | Node results produced by this execution result |
| `startedAt` | [`BigInt!`](../scalar/bigint.md) | Unix epoch time in microseconds when this execution result started |
| `success` | [`JSON`](../scalar/json.md) | Successful value returned by the execution result |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionResult was last updated |
