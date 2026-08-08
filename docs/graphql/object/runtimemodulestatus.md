---
title: RuntimeModuleStatus
---

Detailed status information for a runtime module

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModuleStatus was created |
| `id` | [`RuntimeModuleStatusID!`](../scalar/runtimemodulestatusid.md) | Global ID of this RuntimeModuleStatus |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime module |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current status of the runtime module |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModuleStatus was last updated |
| `uptimes` | [`[Float!]!`](../scalar/float.md) | Uptime percentage for each of the last 14 days, index 0 is today |
