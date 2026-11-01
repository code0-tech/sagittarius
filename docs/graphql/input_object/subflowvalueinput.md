---
title: SubFlowValueInput
---

Input type for sub-flow parameter values

## Fields

| Name | Type | Description |
|------|------|-------------|
| `description` | [`String`](../scalar/string.md) | The sub-flow description |
| `functionIdentifier` | [`String`](../scalar/string.md) | The function identifier to execute |
| `name` | [`String`](../scalar/string.md) | The sub-flow name |
| `parameters` | [`[SubFlowValueParameterInput!]`](../input_object/subflowvalueparameterinput.md) | The sub-flow parameters |
| `signature` | [`String!`](../scalar/string.md) | The sub-flow signature |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The starting node to execute |
