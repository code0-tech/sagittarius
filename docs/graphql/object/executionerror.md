---
title: ExecutionError
---

Represents an execution error returned by the runtime

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `category` | [`String`](../scalar/string.md) | Category of the runtime error |
| `code` | [`String`](../scalar/string.md) | Code of the runtime error |
| `dependencies` | [`JSON!`](../scalar/json.md) | Dependency versions for the runtime error |
| `details` | [`JSON`](../scalar/json.md) | Structured runtime error details |
| `message` | [`String`](../scalar/string.md) | Message of the runtime error |
| `timestamp` | [`BigInt`](../scalar/bigint.md) | Unix epoch runtime timestamp in microseconds for the error |
| `version` | [`String`](../scalar/string.md) | Runtime version that returned the error |
