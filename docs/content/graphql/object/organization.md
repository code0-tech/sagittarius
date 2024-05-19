---
title: Organization
---

Represents a Organization

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this Organization was created |
| `id` | [`OrganizationID!`](../scalar/organizationid.md) | Global ID of this Organization |
| `members` | [`OrganizationMemberConnection!`](../object/organizationmemberconnection.md) | Members of the organization |
| `name` | [`String!`](../scalar/string.md) | Name of the organization |
| `organizationLicenses` | [`OrganizationLicenseConnection!`](../object/organizationlicenseconnection.md) | Licenses of the organization |
| `projects` | [`OrganizationProjectConnection!`](../object/organizationprojectconnection.md) | Projects of the organization |
| `roles` | [`OrganizationRoleConnection!`](../object/organizationroleconnection.md) | Roles of the organization |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this Organization was last updated |

