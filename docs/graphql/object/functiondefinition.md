---
title: FunctionDefinition
---

Represents a function definition

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[Translation!]`](../object/translation.md) | Name of the function |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this FunctionDefinition was created |
| `deprecationMessages` | [`[Translation!]`](../object/translation.md) | Deprecation message of the function |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Description of the function |
| `displayMessages` | [`[Translation!]`](../object/translation.md) | Display message of the function |
| `documentations` | [`[Translation!]`](../object/translation.md) | Documentation of the function |
| `id` | [`FunctionDefinitionID!`](../scalar/functiondefinitionid.md) | Global ID of this FunctionDefinition |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the function |
| `names` | [`[Translation!]`](../object/translation.md) | Name of the function |
| `parameterDefinitions` | [`ParameterDefinitionConnection`](../object/parameterdefinitionconnection.md) | Parameters of the function |
| `referencedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | All data types referenced within this function definition |
| `runtimeFunctionDefinition` | [`RuntimeFunctionDefinition`](../object/runtimefunctiondefinition.md) | Runtime function definition |
| `signature` | [`String!`](../scalar/string.md) | Signature of the function |
| `throwsError` | [`Boolean!`](../scalar/boolean.md) | Indicates if the function can throw an error |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this FunctionDefinition was last updated |

