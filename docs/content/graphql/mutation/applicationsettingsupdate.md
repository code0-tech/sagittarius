---
title: applicationSettingsUpdate
---

Update application settings.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `teamCreationRestricted` | [`Boolean`](../scalar/boolean.md) | Set if team creation is restricted to administrators. |
| `userRegistrationEnabled` | [`Boolean`](../scalar/boolean.md) | Set if user registration is enabled. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `applicationSettings` | [`ApplicationSettings`](../object/applicationsettings.md) | The updated application settings. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../union/error.md) | Errors encountered during execution of the mutation. |
