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
| `genericKeys` | [`[String!]`](../scalar/string.md) | Generic keys of the function |
| `id` | [`FunctionDefinitionID!`](../scalar/functiondefinitionid.md) | Global ID of this FunctionDefinition |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the function |
| `names` | [`[Translation!]`](../object/translation.md) | Name of the function |
| `parameterDefinitions` | [`ParameterDefinitionConnection`](../object/parameterdefinitionconnection.md) | Parameters of the function |
| `returnType` | [`DataTypeIdentifier`](../object/datatypeidentifier.md) | Return type of the function |
| `runtimeFunctionDefinition` | [`RuntimeFunctionDefinition`](../object/runtimefunctiondefinition.md) | Runtime function definition |
| `throwsError` | [`Boolean!`](../scalar/boolean.md) | Indicates if the function can throw an error |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this FunctionDefinition was last updated |

