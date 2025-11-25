---
title: Query
---

Root Query type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `application` | [`Application!`](../object/application.md) | Get application information |
| `currentAuthentication` | [`Authentication`](../union/authentication.md) | Get the currently logged in authentication |
| `currentUser` | [`User`](../object/user.md) | Get the currently logged in user |
| `globalRuntimes` | [`RuntimeConnection!`](../object/runtimeconnection.md) | Find runtimes |
| `organizations` | [`OrganizationConnection!`](../object/organizationconnection.md) | Find organizations |
| `userAbilities` | [`InstanceUserAbilities!`](../object/instanceuserabilities.md) | Abilities for the current user on this Instance |
| `users` | [`UserConnection!`](../object/userconnection.md) | Find users |

## Fields with arguments

### echo

Field available for use to test API access

Returns [`String!`](../scalar/string.md).

| Name | Type | Description |
|------|------|-------------|
| `message` | [`String!`](../scalar/string.md) | String to echo as response |

### namespace

Find a namespace

Returns [`Namespace`](../object/namespace.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`NamespaceID!`](../scalar/namespaceid.md) | GlobalID of the target namespace |

### node

Fetches an object given its ID

Returns [`Node`](../interface/node.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`ID!`](../scalar/id.md) | ID of the object |

### nodes

Fetches a list of objects given a list of IDs

Returns [`[Node]`](../interface/node.md).

| Name | Type | Description |
|------|------|-------------|
| `ids` | [`[ID!]!`](../scalar/id.md) | IDs of the objects |

### organization

Find a organization

Returns [`Organization`](../object/organization.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`OrganizationID`](../scalar/organizationid.md) | GlobalID of the target organization |
| `name` | [`String`](../scalar/string.md) | Name of the target organization |

### user

Find a user

Returns [`User`](../object/user.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`UserID!`](../scalar/userid.md) | GlobalID of the target user |
