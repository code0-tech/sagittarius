---
title: DataType
---

Represents a DataType

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this DataType was created |
| `genericKeys` | [`[String!]`](../scalar/string.md) | Generic keys of the datatype |
| `id` | [`DataTypeID!`](../scalar/datatypeid.md) | Global ID of this DataType |
| `identifier` | [`String!`](../scalar/string.md) | The identifier scoped to the namespace |
| `name` | [`TranslationConnection!`](../object/translationconnection.md) | Names of the flow type setting |
| `namespace` | [`Namespace`](../object/namespace.md) | The namespace where this datatype belongs to |
| `parent` | [`DataTypeIdentifier`](../union/datatypeidentifier.md) | The parent datatype |
| `rules` | [`DataTypeRuleConnection!`](../object/datatyperuleconnection.md) | Rules of the datatype |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this DataType was last updated |
| `variant` | [`DataTypeVariant!`](../enum/datatypevariant.md) | The type of the datatype |

