---
title: teamMembersInvite
---

Invite a new member to a team.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `teamId` | [`TeamID!`](../scalar/teamid.md) | The id of the team which this member will belong to |
| `userId` | [`UserID!`](../scalar/userid.md) | The id of the user to invite |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationMember` | [`OrganizationMember`](../object/organizationmember.md) | The newly created organization member |
