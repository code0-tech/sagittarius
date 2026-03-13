---
title: DataTypeRuleConfigInput
---

Input type for the config of a data type rule

## Fields

| Name | Type | Description |
|------|------|-------------|
| `dataTypeIdentifier` | [`DataTypeIdentifierInput`](../input_object/datatypeidentifierinput.md) | Data type identifier |
| `from` | [`Int`](../scalar/int.md) | The minimum value of the range |
| `inputTypes` | [`[DataTypeRuleInputTypeConfigInput!]`](../input_object/datatyperuleinputtypeconfiginput.md) | The input types that can be used in this data type rule |
| `items` | [`[JSON!]`](../scalar/json.md) | The items of the rule |
| `key` | [`String`](../scalar/string.md) | The key of the rule |
| `pattern` | [`String`](../scalar/string.md) | The regex pattern to match against the data type value. |
| `steps` | [`Int`](../scalar/int.md) | The step value for the range, if applicable |
| `to` | [`Int`](../scalar/int.md) | The maximum value of the range |
