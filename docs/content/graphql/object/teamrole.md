---
title: TeamRole
---

Represents a team role.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[OrganizationRoleAbility!]!`](../enum/organizationroleability.md) | The abilities the role is granted |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this TeamRole was created |
| `id` | [`TeamRoleID!`](../scalar/teamroleid.md) | Global ID of this TeamRole |
| `name` | [`String!`](../scalar/string.md) | The name of this role |
| `team` | [`Team!`](../object/team.md) | The team where this role belongs to |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this TeamRole was last updated |

