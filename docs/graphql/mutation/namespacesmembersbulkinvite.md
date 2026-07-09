---
title: namespacesMembersBulkInvite
---

Invite multiple new members to a namespace.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | The id of the namespace which these members will belong to |
| `userIds` | [`[UserID!]!`](../scalar/userid.md) | The ids of the users to invite |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `namespaceMembers` | [`[NamespaceMember!]`](../object/namespacemember.md) | The newly created namespace members |
