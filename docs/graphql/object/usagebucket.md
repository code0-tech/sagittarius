---
title: UsageBucket
---

Aggregated usage for a single day, week or month bucket

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `periodEnd` | [`ISO8601Date!`](../scalar/iso8601date.md) | End date of this usage bucket (inclusive) |
| `periodStart` | [`ISO8601Date!`](../scalar/iso8601date.md) | Start date of this usage bucket (inclusive) |
| `usage` | [`BigInt!`](../scalar/bigint.md) | Number of events (e.g. executions, ai generations) in this bucket |
| `value` | [`Float!`](../scalar/float.md) | Aggregated value for this bucket (e.g. execution time in microseconds, ai usage in tokens) |
