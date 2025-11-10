---
title: ReferenceValue
---

Represents a reference value in the system.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ReferenceValue was created |
| `dataTypeIdentifier` | [`DataTypeIdentifier!`](../object/datatypeidentifier.md) | The identifier of the data type this reference value belongs to. |
| `id` | [`ReferenceValueID!`](../scalar/referencevalueid.md) | Global ID of this ReferenceValue |
| `nodeFunction` | [`NodeFunction!`](../object/nodefunction.md) | The referenced value. |
| `referencePath` | [`[ReferencePath!]!`](../object/referencepath.md) | The paths associated with this reference value. |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ReferenceValue was last updated |

