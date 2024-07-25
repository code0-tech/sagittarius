---
title: usersMfaTotpValidateSecret
---

Generates an encrypted totp secret

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `currentTotp` | [`String!`](../scalar/string.md) | The current totp at the time to verify the mfa
                                                        authentication device |
| `secret` | [`String!`](../scalar/string.md) | The signed secret from the generation |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
| `user` | [`User`](../object/user.md) | The modified user |
