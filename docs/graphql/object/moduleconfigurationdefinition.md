---
title: ModuleConfigurationDefinition
---

Represents a module configuration definition

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ModuleConfigurationDefinition was created |
| `defaultValue` | [`JSON`](../scalar/json.md) | Default value of the module configuration definition |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Descriptions of the module configuration definition |
| `hidden` | [`Boolean!`](../scalar/boolean.md) | Indicates if the configuration definition is hidden |
| `id` | [`ModuleConfigurationDefinitionID!`](../scalar/moduleconfigurationdefinitionid.md) | Global ID of this ModuleConfigurationDefinition |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the module configuration definition |
| `linkedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this module configuration definition |
| `names` | [`[Translation!]`](../object/translation.md) | Names of the module configuration definition |
| `optional` | [`Boolean!`](../scalar/boolean.md) | Indicates if the configuration definition is optional |
| `runtimeModule` | [`RuntimeModule!`](../object/runtimemodule.md) | Runtime module of the configuration definition |
| `type` | [`String!`](../scalar/string.md) | Type of the module configuration definition |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ModuleConfigurationDefinition was last updated |
