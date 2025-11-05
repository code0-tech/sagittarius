---
title: Namespace
---

Represents a Namespace

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Namespace was created |
| `id` | [`NamespaceID!`](../scalar/namespaceid.md) | Global ID of this Namespace |
| `members` | [`NamespaceMemberConnection!`](../object/namespacememberconnection.md) | Members of the namespace |
| `namespaceLicenses` | [`NamespaceLicenseConnection!`](../object/namespacelicenseconnection.md) | (EE only) Licenses of the namespace |
| `parent` | [`NamespaceParent!`](../union/namespaceparent.md) | Parent of this namespace |
| `projects` | [`NamespaceProjectConnection!`](../object/namespaceprojectconnection.md) | Projects of the namespace |
| `roles` | [`NamespaceRoleConnection!`](../object/namespaceroleconnection.md) | Roles of the namespace |
| `runtimes` | [`RuntimeConnection!`](../object/runtimeconnection.md) | Runtime of the namespace |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Namespace was last updated |
| `userAbilities` | [`NamespaceUserAbilities!`](../object/namespaceuserabilities.md) | Abilities for the current user on this Namespace |

