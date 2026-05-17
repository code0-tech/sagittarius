---
title: Application
---

Represents the application instance

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `currentLicense` | [`License`](../object/license.md) | (EE only) Currently active license of the instance |
| `legalNoticeUrl` | [`String`](../scalar/string.md) | URL to the legal notice page |
| `licenses` | [`LicenseConnection!`](../object/licenseconnection.md) | (EE only) Licenses of the instance |
| `metadata` | [`Metadata`](../object/metadata.md) | Metadata about the application |
| `privacyUrl` | [`String`](../scalar/string.md) | URL to the privacy policy page |
| `settings` | [`ApplicationSettings`](../object/applicationsettings.md) | Global application settings |
| `termsAndConditionsUrl` | [`String`](../scalar/string.md) | URL to the terms and conditions page |
| `userAbilities` | [`ApplicationUserAbilities!`](../object/applicationuserabilities.md) | Abilities for the current user on this Application |
