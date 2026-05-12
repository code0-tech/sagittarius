---
title: Namespace
---

Represents a Namespace

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Namespace was created |
| `currentLicense` | [`License`](../object/license.md) | (Cloud only) Currently active license of the namespace |
| `id` | [`NamespaceID!`](../scalar/namespaceid.md) | Global ID of this Namespace |
| `licenses` | [`LicenseConnection!`](../object/licenseconnection.md) | (Cloud only) Licenses of the namespace |
| `members` | [`NamespaceMemberConnection!`](../object/namespacememberconnection.md) | Members of the namespace |
| `parent` | [`NamespaceParent!`](../union/namespaceparent.md) | Parent of this namespace |
| `projects` | [`NamespaceProjectConnection!`](../object/namespaceprojectconnection.md) | Projects of the namespace |
| `roles` | [`NamespaceRoleConnection!`](../object/namespaceroleconnection.md) | Roles of the namespace |
| `runtimes` | [`RuntimeConnection!`](../object/runtimeconnection.md) | Runtime of the namespace |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Namespace was last updated |
| `userAbilities` | [`NamespaceUserAbilities!`](../object/namespaceuserabilities.md) | Abilities for the current user on this Namespace |

## Fields with arguments

### dailyRuntimeUsages

Daily runtime usage entries for this namespace

Returns [`DailyRuntimeUsageConnection!`](../object/dailyruntimeusageconnection.md).

| Name | Type | Description |
|------|------|-------------|
| `after` | [`String`](../scalar/string.md) | Returns the elements in the list that come after the specified cursor. |
| `before` | [`String`](../scalar/string.md) | Returns the elements in the list that come before the specified cursor. |
| `first` | [`Int`](../scalar/int.md) | Returns the first _n_ elements from the list. |
| `flowId` | [`FlowID`](../scalar/flowid.md) | Only return usage entries for this flow |
| `from` | [`Date`](../scalar/date.md) | Only return usage entries on or after this day |
| `last` | [`Int`](../scalar/int.md) | Returns the last _n_ elements from the list. |
| `to` | [`Date`](../scalar/date.md) | Only return usage entries on or before this day |

### project

Query a project by its id

Returns [`NamespaceProject`](../object/namespaceproject.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | GlobalID of the target project |
