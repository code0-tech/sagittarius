---
title: ActionStatus
---

An action status information entry

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `configurations` | [`RuntimeStatusConfigurationConnection!`](../object/runtimestatusconfigurationconnection.md) | The detailed configuration entries for this action status |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ActionStatus was created |
| `id` | [`ActionStatusID!`](../scalar/actionstatusid.md) | Global ID of this ActionStatus |
| `identifier` | [`String!`](../scalar/string.md) | The unique identifier for this action status |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current action status |
| `type` | [`RuntimeStatusType!`](../enum/runtimestatustype.md) | The type of runtime status information |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ActionStatus was last updated |
