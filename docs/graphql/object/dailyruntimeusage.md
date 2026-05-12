---
title: DailyRuntimeUsage
---

Represents runtime usage for a flow on a specific day

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this DailyRuntimeUsage was created |
| `day` | [`Date!`](../scalar/date.md) | The day this usage was recorded for |
| `flow` | [`Flow`](../object/flow.md) | The flow this usage was recorded for |
| `id` | [`DailyRuntimeUsageID!`](../scalar/dailyruntimeusageid.md) | Global ID of this DailyRuntimeUsage |
| `namespace` | [`Namespace!`](../object/namespace.md) | The namespace this usage belongs to |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this DailyRuntimeUsage was last updated |
| `usage` | [`Float!`](../scalar/float.md) | The accumulated runtime usage for the day |
