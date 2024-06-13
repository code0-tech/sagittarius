---
title: namespaceMembersDelete
---

Remove a member from a namespace.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `namespaceMemberId` | [`NamespaceMemberID!`](../scalar/namespacememberid.md) | The id of the namespace member to remove |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `namespaceMember` | [`NamespaceMember`](../object/namespacemember.md) | The removed namespace member |
