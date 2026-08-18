---
title: InlineReferenceValue
---

Represents a single inline reference addressable via `${signature}` inside a literal value.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this InlineReferenceValue was created |
| `id` | [`InlineReferenceValueID!`](../scalar/inlinereferencevalueid.md) | Global ID of this InlineReferenceValue |
| `signature` | [`String!`](../scalar/string.md) | The key addressed via `${signature}`. |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this InlineReferenceValue was last updated |
| `value` | [`NodeParameterValue!`](../union/nodeparametervalue.md) | The value this reference resolves to. |
