---
title: organizationMembersDelete
---

Remove a new member to an organization.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `organizationMemberId` | [`OrganizationMemberID!`](../scalar/organizationmemberid.md) | The id of the organization member which will removed |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `organizationMember` | [`OrganizationMember`](../object/organizationmember.md) | The removed organization member |
