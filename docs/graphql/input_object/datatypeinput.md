---
title: DataTypeInput
---

Input for creation of a data type

## Fields

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[TranslationInput!]`](../input_object/translationinput.md) | Name of the function |
| `displayMessages` | [`[TranslationInput!]`](../input_object/translationinput.md) | Display message of the function |
| `genericKeys` | [`[String!]`](../scalar/string.md) | Generic keys of the datatype |
| `identifier` | [`String!`](../scalar/string.md) | The identifier of the datatype |
| `name` | [`[TranslationInput!]!`](../input_object/translationinput.md) | Names of the flow type setting |
| `rules` | [`[DataTypeRuleInput!]!`](../input_object/datatyperuleinput.md) | Rules of the datatype |
| `variant` | [`DataTypeVariant!`](../enum/datatypevariant.md) | The type of the datatype |
