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

### aiUsage

AI generation usage of this namespace, bucketed by day, week or month

Returns [`[UsageBucket!]!`](../object/usagebucket.md).

| Name | Type | Description |
|------|------|-------------|
| `afterDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | Start of the usage range (inclusive) |
| `aggregation` | [`UsageAggregation`](../enum/usageaggregation.md) | Granularity to bucket usage into |
| `beforeDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | End of the usage range (inclusive) |

### project

Query a project by its id

Returns [`NamespaceProject`](../object/namespaceproject.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | GlobalID of the target project |

### runtimeUsage

Execution usage of this namespace, bucketed by day, week or month

Returns [`[UsageBucket!]!`](../object/usagebucket.md).

| Name | Type | Description |
|------|------|-------------|
| `afterDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | Start of the usage range (inclusive) |
| `aggregation` | [`UsageAggregation`](../enum/usageaggregation.md) | Granularity to bucket usage into |
| `beforeDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | End of the usage range (inclusive) |
