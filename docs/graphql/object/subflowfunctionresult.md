---
title: SubFlowFunctionResult
---

A sub-flow function result returned by a node execution, mirroring Tucana SubFlowFunctionResult.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `description` | [`String`](../scalar/string.md) | Description of the sub-flow function. |
| `function` | [`SubFlowFunction`](../object/subflowfunction.md) | The sub-flow function that was executed. |
| `inputSchema` | [`JSON`](../scalar/json.md) | JSON schema describing the sub-flow function input. |
| `name` | [`String`](../scalar/string.md) | Name of the sub-flow function. |
| `outputSchema` | [`JSON`](../scalar/json.md) | JSON schema describing the sub-flow function output. |
| `subflowIdentifier` | [`String`](../scalar/string.md) | Identifier of the sub-flow that produced this result. |
