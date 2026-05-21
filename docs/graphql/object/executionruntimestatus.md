---
title: ExecutionRuntimeStatus
---

An execution runtime status information entry

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionRuntimeStatus was created |
| `id` | [`ExecutionRuntimeStatusID!`](../scalar/executionruntimestatusid.md) | Global ID of this ExecutionRuntimeStatus |
| `identifier` | [`String!`](../scalar/string.md) | The unique identifier for this execution status |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current execution status |
| `type` | [`RuntimeStatusType!`](../enum/runtimestatustype.md) | The type of runtime status information |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ExecutionRuntimeStatus was last updated |
