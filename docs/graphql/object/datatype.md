---
title: DataType
---

Represents a DataType

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[Translation!]`](../object/translation.md) | Name of the function |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this DataType was created |
| `dataTypeIdentifiers` | [`DataTypeIdentifierConnection!`](../object/datatypeidentifierconnection.md) | The data type identifiers that are referenced in this data type and its rules |
| `displayMessages` | [`[Translation!]`](../object/translation.md) | Display message of the function |
| `genericKeys` | [`[String!]`](../scalar/string.md) | Generic keys of the datatype |
| `id` | [`DataTypeID!`](../scalar/datatypeid.md) | Global ID of this DataType |
| `identifier` | [`String!`](../scalar/string.md) | The identifier scoped to the namespace |
| `name` | [`[Translation!]!`](../object/translation.md) | Names of the flow type setting |
| `rules` | [`DataTypeRuleConnection!`](../object/datatyperuleconnection.md) | Rules of the datatype |
| `runtime` | [`Runtime`](../object/runtime.md) | The runtime where this datatype belongs to |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this DataType was last updated |
| `variant` | [`DataTypeVariant!`](../enum/datatypevariant.md) | The type of the datatype |

