---
title: RuntimeFlowType
---

Represents a runtime flow type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[Translation!]`](../object/translation.md) | Aliases of the runtime flow type |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFlowType was created |
| `definitionSource` | [`String`](../scalar/string.md) | The source that defines this runtime flow type |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Descriptions of the runtime flow type |
| `displayIcon` | [`String`](../scalar/string.md) | Display icon of the runtime flow type |
| `displayMessages` | [`[Translation!]`](../object/translation.md) | Display message of the runtime flow type |
| `documentations` | [`[Translation!]`](../object/translation.md) | Documentations of the runtime flow type |
| `editable` | [`Boolean!`](../scalar/boolean.md) | Editable status of the runtime flow type |
| `flowTypes` | [`FlowTypeConnection!`](../object/flowtypeconnection.md) | Flow types backed by this runtime flow type |
| `id` | [`RuntimeFlowTypeID!`](../scalar/runtimeflowtypeid.md) | Global ID of this RuntimeFlowType |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the runtime flow type |
| `linkedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this runtime flow type |
| `names` | [`[Translation!]`](../object/translation.md) | Names of the runtime flow type |
| `runtime` | [`Runtime!`](../object/runtime.md) | Runtime of the runtime flow type |
| `runtimeFlowTypeSettings` | [`[RuntimeFlowTypeSetting!]!`](../object/runtimeflowtypesetting.md) | Runtime flow type settings of the runtime flow type |
| `runtimeModule` | [`RuntimeModule!`](../object/runtimemodule.md) | Runtime module of the runtime flow type |
| `signature` | [`String!`](../scalar/string.md) | Signature of the runtime flow type |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFlowType was last updated |
| `version` | [`String!`](../scalar/string.md) | Version of the runtime flow type |
