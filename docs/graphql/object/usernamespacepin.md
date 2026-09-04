---
title: UserNamespacePin
---

Represents a pinned namespace of a user

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this UserNamespacePin was created |
| `id` | [`UserNamespacePinID!`](../scalar/usernamespacepinid.md) | Global ID of this UserNamespacePin |
| `namespace` | [`Namespace`](../object/namespace.md) | The pinned namespace |
| `priority` | [`Int!`](../scalar/int.md) | Ordering priority of the pin, lower is higher priority |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this UserNamespacePin was last updated |
| `user` | [`User!`](../object/user.md) | The user owning this pin |
