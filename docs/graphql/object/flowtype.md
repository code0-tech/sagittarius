---
title: FlowType
---

Represents a flow type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `aliases` | [`[Translation!]`](../object/translation.md) | Name of the function |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this FlowType was created |
| `definitionSource` | [`String`](../scalar/string.md) | The source that defines this flow type |
| `descriptions` | [`[Translation!]`](../object/translation.md) | Descriptions of the flow type |
| `displayIcon` | [`String`](../scalar/string.md) | Display icon of the flow type |
| `displayMessages` | [`[Translation!]`](../object/translation.md) | Display message of the function |
| `documentations` | [`[Translation!]`](../object/translation.md) | Documentations of the flow type |
| `editable` | [`Boolean!`](../scalar/boolean.md) | Editable status of the flow type |
| `flowTypeSettings` | [`[FlowTypeSetting!]!`](../object/flowtypesetting.md) | Flow type settings of the flow type |
| `id` | [`FlowTypeID!`](../scalar/flowtypeid.md) | Global ID of this FlowType |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the flow type |
| `linkedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this flow type |
| `names` | [`[Translation!]`](../object/translation.md) | Names of the flow type |
| `runtime` | [`Runtime!`](../object/runtime.md) | Runtime of the flow type |
| `signature` | [`String!`](../scalar/string.md) | Signature of the flow type |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this FlowType was last updated |
| `version` | [`String!`](../scalar/string.md) | Version of the flow type |

