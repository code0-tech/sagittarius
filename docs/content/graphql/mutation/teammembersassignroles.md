---
title: teamMembersAssignRoles
---

Update the roles a member is assigned to.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `memberId` | [`TeamMemberID!`](../scalar/teammemberid.md) | The id of the member which should be assigned the roles |
| `roleIds` | [`[TeamRoleID!]!`](../scalar/teamroleid.md) | The roles the member should be assigned to the member |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `teamMemberRoles` | [`[TeamMemberRole!]`](../object/teammemberrole.md) | The newly created team member |
