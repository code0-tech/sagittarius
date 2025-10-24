---
title: Flow
---

Represents a flow

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Flow was created |
| `id` | [`FlowID!`](../scalar/flowid.md) | Global ID of this Flow |
| `inputType` | [`DataType`](../object/datatype.md) | The input data type of the flow |
| `name` | [`String!`](../scalar/string.md) | Name of the flow |
| `nodes` | [`NodeFunctionConnection!`](../object/nodefunctionconnection.md) | Nodes of the flow |
| `returnType` | [`DataType`](../object/datatype.md) | The return data type of the flow |
| `settings` | [`FlowSettingConnection!`](../object/flowsettingconnection.md) | The settings of the flow |
| `startingNodeId` | [`NodeFunctionID!`](../scalar/nodefunctionid.md) | The ID of the starting node of the flow |
| `type` | [`FlowType!`](../object/flowtype.md) | The flow type of the flow |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Flow was last updated |

