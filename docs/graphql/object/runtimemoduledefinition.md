---
title: RuntimeModuleDefinition
---

A runtime module definition endpoint

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModuleDefinition was created |
| `endpoint` | [`String!`](../scalar/string.md) | Endpoint path of the module definition |
| `flowTypes` | [`FlowTypeConnection!`](../object/flowtypeconnection.md) | Flow types this module definition applies to |
| `host` | [`String!`](../scalar/string.md) | Host of the module definition endpoint |
| `id` | [`RuntimeModuleDefinitionID!`](../scalar/runtimemoduledefinitionid.md) | Global ID of this RuntimeModuleDefinition |
| `port` | [`BigInt!`](../scalar/bigint.md) | Port of the module definition endpoint |
| `protocol` | [`String!`](../scalar/string.md) | Protocol of the module definition endpoint |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeModuleDefinition was last updated |
