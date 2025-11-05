---
title: NamespaceMember
---

Represents a namespace member

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceMember was created |
| `id` | [`NamespaceMemberID!`](../scalar/namespacememberid.md) | Global ID of this NamespaceMember |
| `memberRoles` | [`NamespaceMemberRoleConnection!`](../object/namespacememberroleconnection.md) | Memberroles of the member |
| `namespace` | [`Namespace!`](../object/namespace.md) | Namespace this member belongs to |
| `roles` | [`NamespaceRoleConnection!`](../object/namespaceroleconnection.md) | Roles of the member |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this NamespaceMember was last updated |
| `user` | [`User!`](../object/user.md) | User this member belongs to |
| `userAbilities` | [`NamespaceMemberUserAbilities!`](../object/namespacememberuserabilities.md) | Abilities for the current user on this NamespaceMember |

