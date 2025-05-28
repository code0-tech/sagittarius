---
title: namespacesProjectsFlowsCreate
---

Creates a new flow.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `flow` | [`FlowInput!`](../input_object/flowinput.md) |  |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `flow` | [`Flow`](../object/flow.md) | The newly created flow. |
