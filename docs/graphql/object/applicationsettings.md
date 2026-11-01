---
title: ApplicationSettings
---

Represents the application settings

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `adminStatusVisible` | [`Boolean!`](../scalar/boolean.md) | Shows if admin status can be queried by non-administrators |
| `identityProviders` | [`IdentityProviderConnection!`](../object/identityproviderconnection.md) | List of configured identity providers |
| `legalNoticeUrl` | [`String`](../scalar/string.md) | URL to the legal notice page |
| `organizationCreationRestricted` | [`Boolean!`](../scalar/boolean.md) | Shows if organization creation is restricted to administrators |
| `privacyUrl` | [`String`](../scalar/string.md) | URL to the privacy policy page |
| `runtimeMaxHeartbeatIntervalMinutes` | [`Int!`](../scalar/int.md) | The maximum amount of minutes a runtime is shown as connected after the last heartbeat |
| `termsAndConditionsUrl` | [`String`](../scalar/string.md) | URL to the terms and conditions page |
| `userRegistrationEnabled` | [`Boolean!`](../scalar/boolean.md) | Shows if user registration is enabled |
