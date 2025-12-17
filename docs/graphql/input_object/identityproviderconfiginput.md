---
title: IdentityProviderConfigInput
---

Input for identity provider configuration. Contains fields for both OIDC and SAML.

## Fields

| Name | Type | Description |
|------|------|-------------|
| `attributeStatements` | [`JSON`](../scalar/json.md) | List of attribute statements for the identity provider |
| `authorizationUrl` | [`String`](../scalar/string.md) | The authorization URL for the OIDC identity provider |
| `clientId` | [`String`](../scalar/string.md) | The client ID for the OIDC identity provider |
| `clientSecret` | [`String`](../scalar/string.md) | The client secret for the OIDC identity provider |
| `metadataUrl` | [`String`](../scalar/string.md) | Optional metadata URL to fetch metadata (alternative to settings) |
| `providerName` | [`String`](../scalar/string.md) | The name of the identity provider |
| `redirectUri` | [`String`](../scalar/string.md) | The redirect URI for the OIDC identity provider |
| `responseSettings` | [`JSON`](../scalar/json.md) | The SAML response settings for the identity provider |
| `settings` | [`JSON`](../scalar/json.md) | The SAML settings for the identity provider |
| `userDetailsUrl` | [`String`](../scalar/string.md) | The user details URL for the OIDC identity provider |
