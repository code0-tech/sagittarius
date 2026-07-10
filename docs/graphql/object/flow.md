---
title: Flow
---

Represents a flow

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Flow was created |
| `disabledReason` | [`FlowDisabledReason`](../enum/flowdisabledreason.md) | The reason why the flow is disabled, if it is disabled |
| `executionResults` | [`ExecutionResultConnection!`](../object/executionresultconnection.md) | Execution results of the flow |
| `id` | [`FlowID!`](../scalar/flowid.md) | Global ID of this Flow |
| `linkedDataTypes` | [`DataTypeConnection!`](../object/datatypeconnection.md) | The data types that are referenced in this flow |
| `name` | [`String!`](../scalar/string.md) | Name of the flow |
| `nodes` | [`NodeFunctionConnection!`](../object/nodefunctionconnection.md) | Nodes of the flow |
| `project` | [`NamespaceProject!`](../object/namespaceproject.md) | The project the flow belongs to |
| `settings` | [`FlowSettingConnection!`](../object/flowsettingconnection.md) | The settings of the flow |
| `signature` | [`String!`](../scalar/string.md) | The signature of the flow |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The ID of the starting node of the flow |
| `type` | [`FlowType!`](../object/flowtype.md) | The flow type of the flow |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Flow was last updated |
| `userAbilities` | [`FlowUserAbilities!`](../object/flowuserabilities.md) | Abilities for the current user on this Flow |
| `validationDiagnostics` | [`[FlowValidationDiagnostic!]!`](../object/flowvalidationdiagnostic.md) | The latest validation diagnostics of the flow |
| `validationStatus` | [`FlowValidationStatus!`](../enum/flowvalidationstatus.md) | The validation status of the flow |

## Fields with arguments

### executionResult

Find an execution result by runtime identifier

Returns [`ExecutionResult`](../object/executionresult.md).

| Name | Type | Description |
|------|------|-------------|
| `executionIdentifier` | [`String!`](../scalar/string.md) | Runtime identifier of the execution result |
