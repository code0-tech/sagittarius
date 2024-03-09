---
title: OrganizationRole
---

Represents an organization role.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `abilities` | [`[OrganizationRoleAbility!]!`](../enum/organizationroleability.md) | The abilities the role is granted |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this OrganizationRole was created |
| `id` | [`OrganizationRoleID!`](../scalar/organizationroleid.md) | Global ID of this OrganizationRole |
| `name` | [`String!`](../scalar/string.md) | The name of this role |
| `organization` | [`Organization!`](../object/organization.md) | The organization where this role belongs to |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this OrganizationRole was last updated |

