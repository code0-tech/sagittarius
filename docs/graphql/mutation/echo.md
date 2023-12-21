---
title: echo
---

A mutation that does not perform any changes.

This is expected to be used for testing of endpoints, to verify
that a user has mutation access.


## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[String!]`](../scalar/string.md) | Errors to return to the user. |
| `message` | [`String`](../scalar/string.md) | Message to return to the user. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[String!]!`](../scalar/string.md) | Errors encountered during execution of the mutation. |
| `message` | [`String`](../scalar/string.md) | Message returned to the user. |
