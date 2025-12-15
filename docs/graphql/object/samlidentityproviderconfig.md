---
title: SamlIdentityProviderConfig
---

Represents the configuration for a SAML identity provider.

For more information see: https://github.com/code0-tech/code0-identities/blob/0.0.3/README.md#saml

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `attributeStatements` | [`JSON!`](../scalar/json.md) | List of attribute statements for the SAML identity provider |
| `metadataUrl` | [`String`](../scalar/string.md) | The metadata url to fetch the metadatas (replacement for settings) |
| `providerName` | [`String!`](../scalar/string.md) | The name of the SAML identity provider |
| `responseSettings` | [`JSON!`](../scalar/json.md) | The SAML response settings for the identity provider |
| `settings` | [`JSON!`](../scalar/json.md) | The SAML settings for the identity provider |

