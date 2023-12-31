---
title: Query
---

Root Query type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `currentAuthorization` | [`Authorization`](../union/authorization.md) | Get the currently logged in authorization |
| `currentUser` | [`User`](../object/user.md) | Get the currently logged in user |

## Fields with arguments

### echo

Field available for use to test API access

Returns [`String!`](../scalar/string.md).

| Name | Type | Description |
|------|------|-------------|
| `message` | [`String!`](../scalar/string.md) | String to echo as response |

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

### team

Find a team

Returns [`Team`](../object/team.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`TeamID`](../scalar/teamid.md) | GlobalID of the target team |
| `name` | [`String`](../scalar/string.md) | Name of the target team |
