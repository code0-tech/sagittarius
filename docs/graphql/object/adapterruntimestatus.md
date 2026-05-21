---
title: AdapterRuntimeStatus
---

An adapter runtime status information entry

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `configurations` | [`RuntimeStatusConfigurationConnection!`](../object/runtimestatusconfigurationconnection.md) | The detailed configuration entries for this adapter status |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this AdapterRuntimeStatus was created |
| `id` | [`AdapterRuntimeStatusID!`](../scalar/adapterruntimestatusid.md) | Global ID of this AdapterRuntimeStatus |
| `identifier` | [`String!`](../scalar/string.md) | The unique identifier for this adapter status |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current adapter status |
| `type` | [`RuntimeStatusType!`](../enum/runtimestatustype.md) | The type of runtime status information |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this AdapterRuntimeStatus was last updated |
