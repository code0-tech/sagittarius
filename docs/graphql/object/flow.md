---
title: Flow
---

Represents a flow

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Flow was created |
| `flowId` | [`FlowID!`](../scalar/flowid.md) | The global ID of the flow |
| `id` | [`FlowID!`](../scalar/flowid.md) | Global ID of this Flow |
| `inputType` | [`DataType`](../object/datatype.md) | The input data type of the flow |
| `returnType` | [`DataType`](../object/datatype.md) | The return data type of the flow |
| `settings` | [`[FlowSetting!]`](../object/flowsetting.md) | The settings of the flow |
| `startingNode` | [`NodeFunction!`](../object/nodefunction.md) | The starting node of the flow |
| `type` | [`String!`](../scalar/string.md) | The identifier of the flow type |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Flow was last updated |

