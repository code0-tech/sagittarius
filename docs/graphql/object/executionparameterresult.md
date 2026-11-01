---
title: ExecutionParameterResult
---

Represents a parameter result of an execution node result

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionParameterResult was created |
| `id` | [`ExecutionParameterResultID!`](../scalar/executionparameterresultid.md) | Global ID of this ExecutionParameterResult |
| `position` | [`Int!`](../scalar/int.md) | Position of this parameter result in the node result |
| `subFlowFunctionResult` | [`JSON`](../scalar/json.md) | Sub-flow function result returned for this parameter |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionParameterResult was last updated |
| `value` | [`JSON`](../scalar/json.md) | Raw value returned for this parameter |
