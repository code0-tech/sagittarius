---
title: DataType
---

Represents a DataType

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[Translation!]`](../object/translation.md) | Name of the function |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this DataType was created |
| `displayMessages` | [`[Translation!]`](../object/translation.md) | Display message of the function |
| `genericKeys` | [`[String!]!`](../scalar/string.md) | The generic keys of the datatype |
| `id` | [`DataTypeID!`](../scalar/datatypeid.md) | Global ID of this DataType |
| `identifier` | [`String!`](../scalar/string.md) | The identifier scoped to the namespace |
| `name` | [`[Translation!]!`](../object/translation.md) | Names of the flow type setting |
| `referencedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this data type |
| `rules` | [`DataTypeRuleConnection!`](../object/datatyperuleconnection.md) | Rules of the datatype |
| `runtime` | [`Runtime`](../object/runtime.md) | The runtime where this datatype belongs to |
| `type` | [`String!`](../scalar/string.md) | The type of the datatype |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this DataType was last updated |

