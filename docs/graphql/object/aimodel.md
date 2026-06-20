---
title: AiModel
---

Represents a model available through AI

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `identifier` | [`String!`](../scalar/string.md) | Unique model identifier |
| `name` | [`String!`](../scalar/string.md) | Human-readable model name |
| `tokenCost` | [`Float!`](../scalar/float.md) | Token cost for using this model |
| `types` | [`[AiModelType!]!`](../enum/aimodeltype.md) | Capabilities supported by this model |
