---
title: ParameterDefinition
---

Represents a parameter definition

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ParameterDefinition was created |
| `defaultValue` | [`JSON`](../scalar/json.md) | Default value of the parameter |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Description of the parameter |
| `documentations` | [`[Translation!]`](../object/translation.md) | Documentation of the parameter |
| `hidden` | [`Boolean!`](../scalar/boolean.md) | Indicates if the parameter is hidden |
| `id` | [`ParameterDefinitionID!`](../scalar/parameterdefinitionid.md) | Global ID of this ParameterDefinition |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the parameter |
| `names` | [`[Translation!]`](../object/translation.md) | Name of the parameter |
| `optional` | [`Boolean!`](../scalar/boolean.md) | Indicates if the parameter is optional |
| `runtimeParameterDefinition` | [`RuntimeParameterDefinition`](../object/runtimeparameterdefinition.md) | Runtime parameter definition |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ParameterDefinition was last updated |
