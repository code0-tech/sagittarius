---
title: namespacesProjectsRuntimeAssignmentsUpdateModuleConfigurations
---

Updates the saved module configurations for a project runtime assignment.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `moduleConfigurations` | [`[ModuleConfigurationInput!]!`](../input_object/moduleconfigurationinput.md) | The full set of saved module configurations for this assignment. |
| `namespaceProjectRuntimeAssignmentId` | [`NamespaceProjectRuntimeAssignmentID!`](../scalar/namespaceprojectruntimeassignmentid.md) | The project runtime assignment to update. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceProjectRuntimeAssignment` | [`NamespaceProjectRuntimeAssignment`](../object/namespaceprojectruntimeassignment.md) | The updated project runtime assignment. |
