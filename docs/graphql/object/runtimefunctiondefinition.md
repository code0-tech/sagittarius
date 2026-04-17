---
title: RuntimeFunctionDefinition
---

Represents a runtime function definition

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[Translation!]`](../object/translation.md) | Aliases |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFunctionDefinition was created |
| `definitionSource` | [`String`](../scalar/string.md) | The source that defines this definition |
| `deprecationMessages` | [`[Translation!]`](../object/translation.md) | Deprecation messages |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Descriptions of the runtime function definition |
| `displayIcon` | [`String`](../scalar/string.md) | Display icon of the runtime function definition |
| `displayMessages` | [`[Translation!]`](../object/translation.md) | Display messages |
| `documentations` | [`[Translation!]`](../object/translation.md) | Documentations of the runtime function definition |
| `functionDefinitions` | [`FunctionDefinitionConnection`](../object/functiondefinitionconnection.md) | Function definitions of the runtime function definition |
| `id` | [`RuntimeFunctionDefinitionID!`](../scalar/runtimefunctiondefinitionid.md) | Global ID of this RuntimeFunctionDefinition |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the runtime function definition |
| `linkedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this runtime function definition |
| `names` | [`[Translation!]`](../object/translation.md) | Names of the runtime function definition |
| `runtime` | [`Runtime!`](../object/runtime.md) | The runtime this runtime function definition belongs to |
| `runtimeParameterDefinitions` | [`RuntimeParameterDefinitionConnection`](../object/runtimeparameterdefinitionconnection.md) | Parameter definitions of the runtime function definition |
| `signature` | [`String!`](../scalar/string.md) | Signature of the runtime function definition |
| `throwsError` | [`Boolean!`](../scalar/boolean.md) | Indicates if the function can throw an error |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFunctionDefinition was last updated |
| `version` | [`String!`](../scalar/string.md) | Version of the runtime function definition |
