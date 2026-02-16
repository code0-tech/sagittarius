---
title: applicationSettingsUpdate
---

Update application settings.

## Arguments

| Name | Type | Description |
|------|------|-------------|
| `adminStatusVisible` | [`Boolean`](../scalar/boolean.md) | Set if admin status can be queried by non-administrators. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `identityProviders` | [`[IdentityProviderInput!]`](../input_object/identityproviderinput.md) | Set the list of configured identity providers. |
| `legalNoticeUrl` | [`String`](../scalar/string.md) | Set the URL to the legal notice page. |
| `organizationCreationRestricted` | [`Boolean`](../scalar/boolean.md) | Set if organization creation is restricted to administrators. |
| `privacyUrl` | [`String`](../scalar/string.md) | Set the URL to the privacy policy page. |
| `termsAndConditionsUrl` | [`String`](../scalar/string.md) | Set the URL to the terms and conditions page. |
| `userRegistrationEnabled` | [`Boolean`](../scalar/boolean.md) | Set if user registration is enabled. |

## Fields

| Name | Type | Description |
|------|------|-------------|
| `application` | [`Application`](../object/application.md) | The whole updated application object. |
| `applicationSettings` | [`ApplicationSettings`](../object/applicationsettings.md) | The updated application settings. |
| `clientMutationId` | [`String`](../scalar/string.md) | A unique identifier for the client performing the mutation. |
| `errors` | [`[Error!]!`](../object/error.md) | Errors encountered during execution of the mutation. |
