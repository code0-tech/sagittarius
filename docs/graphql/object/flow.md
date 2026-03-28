---
title: Flow
---

Represents a flow

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Flow was created |
| `disabledReason` | [`FlowDisabledReason`](../enum/flowdisabledreason.md) | The reason why the flow is disabled, if it is disabled |
| `id` | [`FlowID!`](../scalar/flowid.md) | Global ID of this Flow |
| `inputType` | [`String`](../scalar/string.md) | The input data type of the flow |
| `linkedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this flow |
| `name` | [`String!`](../scalar/string.md) | Name of the flow |
| `nodes` | [`NodeFunctionConnection!`](../object/nodefunctionconnection.md) | Nodes of the flow |
| `project` | [`NamespaceProject!`](../object/namespaceproject.md) | The project the flow belongs to |
| `returnType` | [`String`](../scalar/string.md) | The return data type of the flow |
| `settings` | [`FlowSettingConnection!`](../object/flowsettingconnection.md) | The settings of the flow |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The ID of the starting node of the flow |
| `type` | [`FlowType!`](../object/flowtype.md) | The flow type of the flow |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Flow was last updated |
| `userAbilities` | [`FlowUserAbilities!`](../object/flowuserabilities.md) | Abilities for the current user on this Flow |
| `validationStatus` | [`FlowValidationStatus!`](../enum/flowvalidationstatus.md) | The validation status of the flow |

