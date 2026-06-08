---
title: RuntimeStatus
---

A runtime status information entry

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `configurations` | [`RuntimeStatusConfigurationConnection!`](../object/runtimestatusconfigurationconnection.md) | The detailed configuration entries for this runtime status (only for adapters) |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeStatus was created |
| `id` | [`RuntimeStatusID!`](../scalar/runtimestatusid.md) | Global ID of this RuntimeStatus |
| `identifier` | [`String!`](../scalar/string.md) | The unique identifier for this runtime status |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current status of the runtime |
| `type` | [`RuntimeStatusType!`](../enum/runtimestatustype.md) | Type of the runtime status |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeStatus was last updated |
