---
title: FlowInput
---

Input type for creating or updating a flow

## Fields

| Name | Type | Description |
|------|------|-------------|
| `inputTypeId` | [`ID`](../scalar/id.md) | The ID of the input data type |
| `returnTypeId` | [`ID`](../scalar/id.md) | The ID of the return data type |
| `settings` | [`[FlowSettingInput!]`](../input_object/flowsettinginput.md) | The settings of the flow |
| `startingNode` | [`NodeFunctionInput!`](../input_object/nodefunctioninput.md) | The starting node of the flow |
| `type` | [`String!`](../scalar/string.md) | The identifier of the flow type |
