---
title: RuntimeModule
---

Represents a runtime module

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `author` | [`String!`](../scalar/string.md) | Author of the runtime module |
| `configurationDefinitions` | [`ModuleConfigurationDefinitionConnection!`](../object/moduleconfigurationdefinitionconnection.md) | Configuration definitions of the runtime module |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModule was created |
| `dataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | Data types of the runtime module |
| `definitions` | [`RuntimeModuleDefinitionConnection!`](../object/runtimemoduledefinitionconnection.md) | Endpoint definitions of the runtime module |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Descriptions of the runtime module |
| `documentation` | [`String!`](../scalar/string.md) | Documentation URL of the runtime module |
| `flowTypes` | [`FlowTypeConnection!`](../object/flowtypeconnection.md) | Flow types of the runtime module |
| `functionDefinitions` | [`FunctionDefinitionConnection!`](../object/functiondefinitionconnection.md) | Function definitions of the runtime module |
| `icon` | [`String`](../scalar/string.md) | Icon of the runtime module |
| `id` | [`RuntimeModuleID!`](../scalar/runtimemoduleid.md) | Global ID of this RuntimeModule |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the runtime module |
| `names` | [`[Translation!]`](../object/translation.md) | Names of the runtime module |
| `runtime` | [`Runtime!`](../object/runtime.md) | Runtime of the runtime module |
| `runtimeFlowTypes` | [`RuntimeFlowTypeConnection!`](../object/runtimeflowtypeconnection.md) | Runtime flow types of the runtime module |
| `runtimeFunctionDefinitions` | [`RuntimeFunctionDefinitionConnection!`](../object/runtimefunctiondefinitionconnection.md) | Runtime function definitions of the runtime module |
| `status` | [`RuntimeModuleStatus!`](../object/runtimemodulestatus.md) | The status of the runtime module |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModule was last updated |
| `version` | [`String!`](../scalar/string.md) | Version of the runtime module |
