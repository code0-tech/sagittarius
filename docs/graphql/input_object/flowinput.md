---
title: FlowInput
---

Input type for creating or updating a flow

## Fields

| Name | Type | Description |
|------|------|-------------|
| `inputType` | [`String`](../scalar/string.md) | The input type of the flow |
| `name` | [`String!`](../scalar/string.md) | The name of the flow |
| `nodes` | [`[NodeFunctionInput!]!`](../input_object/nodefunctioninput.md) | The node functions of the flow |
| `returnType` | [`String`](../scalar/string.md) | The return type of the flow |
| `settings` | [`[FlowSettingInput!]`](../input_object/flowsettinginput.md) | The settings of the flow |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The starting node of the flow |
| `type` | [`FlowTypeID!`](../scalar/flowtypeid.md) | The identifier of the flow type |
