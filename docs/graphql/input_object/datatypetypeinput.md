---
title: DataTypeTypeInput
---

Represents a DataType

## Fields

| Name | Type | Description |
|------|------|-------------|
| `genericKeys` | [`[String!]`](../scalar/string.md) | The generic keys for the datatype |
| `identifier` | [`String!`](../scalar/string.md) | The identifier scoped to the namespace |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | The namespace where this datatype belongs to |
| `parentTypeIdentifier` | [`String`](../scalar/string.md) | The identifier of the parent data type, if any |
| `rules` | [`[DataTypeRuleInput!]`](../input_object/datatyperuleinput.md) | The rules for the datatype |
| `variant` | [`DataTypeVariant!`](../enum/datatypevariant.md) | The type of the datatype |
