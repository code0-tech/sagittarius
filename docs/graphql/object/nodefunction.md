---
title: NodeFunction
---

Represents a Node Function

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this NodeFunction was created |
| `id` | [`NodeFunctionID!`](../scalar/nodefunctionid.md) | Global ID of this NodeFunction |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the Node Function |
| `nextNode` | [`NodeFunction`](../object/nodefunction.md) | The next Node Function in the flow |
| `parameters` | [`NodeParameterConnection!`](../object/nodeparameterconnection.md) | The parameters of the Node Function |
| `runtimeFunction` | [`RuntimeFunctionDefinition!`](../object/runtimefunctiondefinition.md) | The definition of the Node Function |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this NodeFunction was last updated |

