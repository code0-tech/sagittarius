---
title: FlowInput
---

Input type for creating or updating a flow

## Fields

| Name | Type | Description |
|------|------|-------------|
| `name` | [`String!`](../scalar/string.md) | The name of the flow |
| `nodes` | [`[NodeFunctionInput!]!`](../input_object/nodefunctioninput.md) | The node functions of the flow |
| `settings` | [`[FlowSettingInput!]`](../input_object/flowsettinginput.md) | The settings of the flow |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The starting node of the flow |
| `type` | [`FlowTypeID!`](../scalar/flowtypeid.md) | The identifier of the flow type |
