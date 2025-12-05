---
title: RuntimeFunctionDefinition
---

Represents a runtime function definition

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFunctionDefinition was created |
| `functionDefinitions` | [`FunctionDefinitionConnection`](../object/functiondefinitionconnection.md) | Function definitions of the runtime function definition |
| `id` | [`RuntimeFunctionDefinitionID!`](../scalar/runtimefunctiondefinitionid.md) | Global ID of this RuntimeFunctionDefinition |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the runtime function definition |
| `runtime` | [`Runtime!`](../object/runtime.md) | The runtime this runtime function definition belongs to |
| `runtimeParameterDefinitions` | [`RuntimeParameterDefinitionConnection`](../object/runtimeparameterdefinitionconnection.md) | Parameter definitions of the runtime function definition |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFunctionDefinition was last updated |

