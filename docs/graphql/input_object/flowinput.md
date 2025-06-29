---
title: FlowInput
---

Input type for creating or updating a flow

## Fields

| Name | Type | Description |
|------|------|-------------|
| `inputType` | [`DataTypeID`](../scalar/datatypeid.md) | The ID of the input data type |
| `returnType` | [`DataTypeID`](../scalar/datatypeid.md) | The ID of the return data type |
| `settings` | [`[FlowSettingInput!]`](../input_object/flowsettinginput.md) | The settings of the flow |
| `startingNode` | [`NodeFunctionInput!`](../input_object/nodefunctioninput.md) | The starting node of the flow |
| `type` | [`FlowTypeID!`](../scalar/flowtypeid.md) | The identifier of the flow type |
