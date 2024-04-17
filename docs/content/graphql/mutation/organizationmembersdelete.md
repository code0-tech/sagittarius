---
title: organizationMembersDelete
---

Remove a member from an organization.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `organizationMemberId` | [`OrganizationMemberID!`](../scalar/organizationmemberid.md) | The id of the organization member to remove |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationMember` | [`OrganizationMember`](../object/organizationmember.md) | The removed organization member |
