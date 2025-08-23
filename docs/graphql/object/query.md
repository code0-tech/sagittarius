---
title: Query
---

Root Query type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `applicationSettings` | [`ApplicationSettings`](../object/applicationsettings.md) | Get global application settings |
| `currentAuthentication` | [`Authentication`](../union/authentication.md) | Get the currently logged in authentication |
| `currentUser` | [`User`](../object/user.md) | Get the currently logged in user |
| `globalRuntimes` | [`RuntimeConnection!`](../object/runtimeconnection.md) | Find runtimes |
| `users` | [`UserConnection!`](../object/userconnection.md) | Find users |

## Fields with arguments

### echo

Field available for use to test API access

Returns [`String!`](../scalar/string.md).

| Name | Type | Description |
|------|------|-------------|
| `message` | [`String!`](../scalar/string.md) | String to echo as response |

### flow

Fetches an flow given by its ID

Returns [`Flow`](../object/flow.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`ID!`](../scalar/id.md) | Id of the flow |

### flows

Fetches all flows in a specific project

Returns [`[Flow!]`](../object/flow.md).

| Name | Type | Description |
|------|------|-------------|
| `projectId` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | Id of the project |

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
