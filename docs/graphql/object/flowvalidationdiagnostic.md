---
title: FlowValidationDiagnostic
---

Represents a diagnostic returned by flow validation

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `code` | [`Int`](../scalar/int.md) | Diagnostic code returned by the validator |
| `message` | [`String`](../scalar/string.md) | Human-readable diagnostic message |
| `nodeId` | [`BigInt`](../scalar/bigint.md) | ID of the node that caused the diagnostic |
| `parameterIndex` | [`Int`](../scalar/int.md) | Index of the parameter that caused the diagnostic |
| `severity` | [`String`](../scalar/string.md) | Diagnostic severity returned by the validator |
