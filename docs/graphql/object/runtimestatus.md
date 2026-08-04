---
title: RuntimeStatus
---

Detailed status information for a runtime

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeStatus was created |
| `id` | [`RuntimeStatusID!`](../scalar/runtimestatusid.md) | Global ID of this RuntimeStatus |
| `lastHeartbeat` | [`Time`](../scalar/time.md) | The timestamp of the last heartbeat received from the runtime |
| `status` | [`RuntimeStatusStatus!`](../enum/runtimestatusstatus.md) | The current status of the runtime |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeStatus was last updated |
| `uptimes` | [`[Float!]!`](../scalar/float.md) | Uptime percentage for each of the last 14 days, index 0 is today |
