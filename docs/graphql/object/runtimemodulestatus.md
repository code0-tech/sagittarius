---
title: RuntimeModuleStatus
---

A runtime module status information entry

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModuleStatus was created |
| `id` | [`RuntimeModuleStatusID!`](../scalar/runtimemodulestatusid.md) | Global ID of this RuntimeModuleStatus |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime module |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current status of the runtime module |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModuleStatus was last updated |
| `uptime` | [`Float!`](../scalar/float.md) | Current uptime percentage for the runtime module |
| `uptimes` | [`[Float!]!`](../scalar/float.md) | Uptime percentages for the last 14 days |
