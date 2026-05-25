---
title: ModuleConfiguration
---

Represents a saved module configuration value for a project runtime assignment.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this ModuleConfiguration was created |
| `definition` | [`ModuleConfigurationDefinition!`](../object/moduleconfigurationdefinition.md) | The configuration definition this saved value belongs to. |
| `id` | [`ModuleConfigurationID!`](../scalar/moduleconfigurationid.md) | Global ID of this ModuleConfiguration |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this ModuleConfiguration was last updated |
| `value` | [`JSON`](../scalar/json.md) | The saved configuration value. |
