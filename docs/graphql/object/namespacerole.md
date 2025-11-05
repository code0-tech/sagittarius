---
title: NamespaceRole
---

Represents a namespace role.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[NamespaceRoleAbility!]!`](../enum/namespaceroleability.md) | The abilities the role is granted |
| `assignedProjects` | [`NamespaceProjectConnection`](../object/namespaceprojectconnection.md) | The projects this role is assigned to |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceRole was created |
| `id` | [`NamespaceRoleID!`](../scalar/namespaceroleid.md) | Global ID of this NamespaceRole |
| `name` | [`String!`](../scalar/string.md) | The name of this role |
| `namespace` | [`Namespace`](../object/namespace.md) | The namespace where this role belongs to |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceRole was last updated |
| `userAbilities` | [`NamespaceRoleUserAbilities!`](../object/namespaceroleuserabilities.md) | Abilities for the current user on this NamespaceRole |

