---
title: velorumGenerateFlow
---

Start a Velorum flow generation job.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `flowId` | [`FlowID`](../scalar/flowid.md) | Flow to update with the prompt |
| `modelIdentifier` | [`String!`](../scalar/string.md) | Selected Velorum model identifier |
| `projectId` | [`NamespaceProjectID!`](../scalar/namespaceprojectid.md) | Project to generate a flow for |
| `prompt` | [`String!`](../scalar/string.md) | Prompt to send to Velorum |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
| `executionIdentifier` | [`String`](../scalar/string.md) | Identifier that can be used to subscribe to the generated flow response. |
