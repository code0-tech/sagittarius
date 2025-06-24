---
title: FlowType
---

Represents a flow type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this FlowType was created |
| `descriptions` | [`TranslationConnection`](../object/translationconnection.md) | Descriptions of the flow type |
| `editable` | [`Boolean!`](../scalar/boolean.md) | Editable status of the flow type |
| `flowTypeSettings` | [`[FlowTypeSetting!]!`](../object/flowtypesetting.md) | Flow type settings of the flow type |
| `id` | [`TypesFlowTypeID!`](../scalar/typesflowtypeid.md) | Global ID of this FlowType |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the flow type |
| `inputType` | [`DataType`](../object/datatype.md) | Input type of the flow type |
| `names` | [`TranslationConnection`](../object/translationconnection.md) | Names of the flow type |
| `returnType` | [`DataType`](../object/datatype.md) | Return type of the flow type |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this FlowType was last updated |

