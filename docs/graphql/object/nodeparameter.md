---
title: NodeParameter
---

Represents a Node parameter

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `cast` | [`String`](../scalar/string.md) | The cast applied to the parameter |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this NodeParameter was created |
| `id` | [`NodeParameterID!`](../scalar/nodeparameterid.md) | Global ID of this NodeParameter |
| `parameterDefinition` | [`ParameterDefinition!`](../object/parameterdefinition.md) | The definition of the parameter |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this NodeParameter was last updated |
| `value` | [`NodeParameterValue`](../union/nodeparametervalue.md) | The value of the parameter |
