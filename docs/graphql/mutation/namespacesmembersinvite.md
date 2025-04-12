---
title: namespacesMembersInvite
---

Invite a new member to a namespace.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceId` | [`NamespaceID!`](../scalar/namespaceid.md) | The id of the namespace which this member will belong to |
| `userId` | [`UserID!`](../scalar/userid.md) | The id of the user to invite |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `namespaceMember` | [`NamespaceMember`](../object/namespacemember.md) | The newly created namespace member |
