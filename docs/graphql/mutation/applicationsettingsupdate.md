---
title: applicationSettingsUpdate
---

Update application settings.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `adminStatusVisible` | [`Boolean`](../scalar/boolean.md) | Set if admin status can be queried by non-administrators. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `organizationCreationRestricted` | [`Boolean`](../scalar/boolean.md) | Set if organization creation is restricted to administrators. |
| `userRegistrationEnabled` | [`Boolean`](../scalar/boolean.md) | Set if user registration is enabled. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `applicationSettings` | [`ApplicationSettings`](../object/applicationsettings.md) | The updated application settings. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
