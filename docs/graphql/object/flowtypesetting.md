---
title: FlowTypeSetting
---

Represents a flow type setting

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this FlowTypeSetting was created |
| `descriptions` | [`[Translation!]!`](../object/translation.md) | Descriptions of the flow type setting |
| `flowType` | [`FlowType`](../object/flowtype.md) | Flow type of the flow type setting |
| `id` | [`FlowTypeSettingID!`](../scalar/flowtypesettingid.md) | Global ID of this FlowTypeSetting |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the flow type setting |
| `names` | [`[Translation!]!`](../object/translation.md) | Names of the flow type setting |
| `referencedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this flow type setting |
| `type` | [`String!`](../scalar/string.md) | Type of the flow type setting |
| `unique` | [`Boolean!`](../scalar/boolean.md) | Unique status of the flow type setting |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this FlowTypeSetting was last updated |

