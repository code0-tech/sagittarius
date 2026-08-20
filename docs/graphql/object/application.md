---
title: Application
---

Represents the application instance

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `currentLicense` | [`License`](../object/license.md) | (EE only) Currently active license of the instance |
| `identityProviders` | [`IdentityProviderBasicConnection!`](../object/identityproviderbasicconnection.md) | Configured identity providers for login and registration |
| `legalNoticeUrl` | [`String`](../scalar/string.md) | URL to the legal notice page |
| `licenses` | [`LicenseConnection!`](../object/licenseconnection.md) | (EE only) Licenses of the instance |
| `metadata` | [`Metadata`](../object/metadata.md) | Metadata about the application |
| `privacyUrl` | [`String`](../scalar/string.md) | URL to the privacy policy page |
| `settings` | [`ApplicationSettings`](../object/applicationsettings.md) | Global application settings |
| `termsAndConditionsUrl` | [`String`](../scalar/string.md) | URL to the terms and conditions page |
| `userAbilities` | [`ApplicationUserAbilities!`](../object/applicationuserabilities.md) | Abilities for the current user on this Application |

## Fields with arguments

### identityProviderLoginUrl

Login URL for a specific identity provider

Returns [`String`](../scalar/string.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`String!`](../scalar/string.md) | ID of the identity provider |

### runtimeUsage

Instance-wide execution usage, bucketed by day, week or month. Only visible to admins.

Returns [`[RuntimeUsageBucket!]`](../object/runtimeusagebucket.md).

| Name | Type | Description |
|------|------|-------------|
| `afterDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | Start of the usage range (inclusive) |
| `aggregation` | [`RuntimeUsageAggregation`](../enum/runtimeusageaggregation.md) | Granularity to bucket usage into |
| `beforeDate` | [`ISO8601Date!`](../scalar/iso8601date.md) | End of the usage range (inclusive) |
