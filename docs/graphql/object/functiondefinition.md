---
title: FunctionDefinition
---

Represents a function definition

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this FunctionDefinition was created |
| `descriptions` | [`TranslationConnection`](../object/translationconnection.md) | Description of the function |
| `documentations` | [`TranslationConnection`](../object/translationconnection.md) | Documentation of the function |
| `id` | [`FunctionDefinitionID!`](../scalar/functiondefinitionid.md) | Global ID of this FunctionDefinition |
| `names` | [`TranslationConnection`](../object/translationconnection.md) | Name of the function |
| `parameterDefinitions` | [`ParameterDefinitionConnection`](../object/parameterdefinitionconnection.md) | Parameters of the function |
| `returnType` | [`DataTypeIdentifier`](../object/datatypeidentifier.md) | Return type of the function |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this FunctionDefinition was last updated |

