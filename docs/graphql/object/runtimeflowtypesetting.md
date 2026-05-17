---
title: RuntimeFlowTypeSetting
---

Represents a runtime flow type setting

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFlowTypeSetting was created |
| `defaultValue` | [`JSON`](../scalar/json.md) | Default value of the runtime flow type setting |
| `descriptions` | [`[Translation!]!`](../object/translation.md) | Descriptions of the runtime flow type setting |
| `id` | [`RuntimeFlowTypeSettingID!`](../scalar/runtimeflowtypesettingid.md) | Global ID of this RuntimeFlowTypeSetting |
| `identifier` | [`String!`](../scalar/string.md) | Identifier of the runtime flow type setting |
| `names` | [`[Translation!]!`](../object/translation.md) | Names of the runtime flow type setting |
| `removedAt` | [`Time`](../scalar/time.md) | The timestamp when this setting was soft removed |
| `runtimeFlowType` | [`RuntimeFlowType!`](../object/runtimeflowtype.md) | Runtime flow type of this setting |
| `unique` | [`String!`](../scalar/string.md) | Unique scope of the runtime flow type setting |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this RuntimeFlowTypeSetting was last updated |
