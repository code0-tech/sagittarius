---
title: SubFlowValue
---

Represents a sub-flow parameter value.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `description` | [`String`](../scalar/string.md) | The sub-flow description. |
| `functionDefinition` | [`FunctionDefinition`](../object/functiondefinition.md) | The resolved function definition to execute. |
| `name` | [`String`](../scalar/string.md) | The sub-flow name. |
| `parameters` | [`[SubFlowValueParameter!]!`](../object/subflowvalueparameter.md) | The sub-flow parameters. |
| `signature` | [`String!`](../scalar/string.md) | The sub-flow signature. |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The starting node to execute. |
