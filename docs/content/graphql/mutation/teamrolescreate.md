---
title: teamRolesCreate
---

Create a new role in a team.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `name` | [`String!`](../scalar/string.md) | The name for the new role |
| `teamId` | [`TeamID!`](../scalar/teamid.md) | The id of the team which this role will belong to |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `teamRole` | [`TeamRole`](../object/teamrole.md) | The newly created team role |
