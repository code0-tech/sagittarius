---
title: SubFlowValueInput
---

Input type for sub-flow parameter values

## Fields

| Name | Type | Description |
|------|------|-------------|
| `functionIdentifier` | [`String`](../scalar/string.md) | The function identifier to execute |
| `settings` | [`[SubFlowValueSettingInput!]`](../input_object/subflowvaluesettinginput.md) | The sub-flow settings |
| `signature` | [`String!`](../scalar/string.md) | The sub-flow signature |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The starting node to execute |
