---
title: namespacesMembersAssignRoles
---

Update the roles a member is assigned to.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `memberId` | [`NamespaceMemberID!`](../scalar/namespacememberid.md) | The id of the member which should be assigned the roles |
| `roleIds` | [`[NamespaceRoleID!]!`](../scalar/namespaceroleid.md) | The roles the member should be assigned to the member |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `member` | [`NamespaceMember`](../object/namespacemember.md) | The member which was assigned the roles |
