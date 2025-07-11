---
title: GenericMapper
---

Represents a mapping between a source data type and a target key for generic values.

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this GenericMapper was created |
| `id` | [`GenericMapperID!`](../scalar/genericmapperid.md) | Global ID of this GenericMapper |
| `source` | [`DataTypeIdentifier!`](../object/datatypeidentifier.md) | The source data type identifier. |
| `target` | [`String!`](../scalar/string.md) | The target key for the generic value. |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this GenericMapper was last updated |

