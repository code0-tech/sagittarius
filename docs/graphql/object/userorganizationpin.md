---
title: UserOrganizationPin
---

Represents a pinned organization of a user

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this UserOrganizationPin was created |
| `id` | [`UserOrganizationPinID!`](../scalar/userorganizationpinid.md) | Global ID of this UserOrganizationPin |
| `organization` | [`Organization`](../object/organization.md) | The pinned organization |
| `priority` | [`Int!`](../scalar/int.md) | Ordering priority of the pin |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this UserOrganizationPin was last updated |
| `user` | [`User!`](../object/user.md) | The user owning this pin |
