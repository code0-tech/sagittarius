---
title: NamespaceProjectRuntimeAssignment
---

Represents a runtime assignment for a project.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `compatible` | [`Boolean!`](../scalar/boolean.md) | Whether the assigned runtime is compatible. |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceProjectRuntimeAssignment was created |
| `id` | [`NamespaceProjectRuntimeAssignmentID!`](../scalar/namespaceprojectruntimeassignmentid.md) | Global ID of this NamespaceProjectRuntimeAssignment |
| `moduleConfigurations` | [`ModuleConfigurationConnection!`](../object/moduleconfigurationconnection.md) | Saved module configuration values for this project runtime assignment. |
| `runtime` | [`Runtime!`](../object/runtime.md) | The assigned runtime. |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceProjectRuntimeAssignment was last updated |
