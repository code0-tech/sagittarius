---
title: UsageBucket
---

Aggregated execution usage for a single day, week or month bucket

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `periodEnd` | [`ISO8601Date!`](../scalar/iso8601date.md) | End date of this usage bucket (inclusive) |
| `periodStart` | [`ISO8601Date!`](../scalar/iso8601date.md) | Start date of this usage bucket (inclusive) |
| `usage` | [`BigInt!`](../scalar/bigint.md) | Number of executions in this bucket |
| `value` | [`Float!`](../scalar/float.md) | Total execution time in this bucket, in seconds |
