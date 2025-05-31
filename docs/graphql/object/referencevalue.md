---
title: ReferenceValue
---

Represents a reference value in the system.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ReferenceValue was created |
| `dataTypeIdentifier` | [`DataTypeIdentifier!`](../union/datatypeidentifier.md) | The identifier of the data type this reference value belongs to. |
| `id` | [`ReferenceValueID!`](../scalar/referencevalueid.md) | Global ID of this ReferenceValue |
| `primaryLevel` | [`Int!`](../scalar/int.md) | The primary level of the reference value. |
| `referencePath` | [`[ReferencePath!]!`](../object/referencepath.md) | The paths associated with this reference value. |
| `secondaryLevel` | [`Int!`](../scalar/int.md) | The secondary level of the reference value. |
| `tertiaryLevel` | [`Int`](../scalar/int.md) | The tertiary level of the reference value, if applicable. |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ReferenceValue was last updated |

