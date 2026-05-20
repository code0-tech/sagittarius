---
title: FlowSubFlow
---

Represents a sub-flow parameter value.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `functionIdentifier` | [`String`](../scalar/string.md) | The function identifier to execute. |
| `settings` | [`[FlowSubFlowSetting!]!`](../object/flowsubflowsetting.md) | The sub-flow settings. |
| `signature` | [`String!`](../scalar/string.md) | The sub-flow signature. |
| `startingNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The starting node to execute. |
