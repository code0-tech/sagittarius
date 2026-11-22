---
title: StorageObject
---

A project-owned stored file (the FILE data type)

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `byteSize` | [`BigInt!`](../scalar/bigint.md) | Size of the file in bytes |
| `checksum` | [`String`](../scalar/string.md) | Content checksum (sha256:...) |
| `contentType` | [`String!`](../scalar/string.md) | MIME type of the file |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this StorageObject was created |
| `downloadUrl` | [`String`](../scalar/string.md) | Short-lived signed absolute URL to fetch the file bytes |
| `expiresAt` | [`Time`](../scalar/time.md) | When the file is scheduled to expire, if ever |
| `fileName` | [`String!`](../scalar/string.md) | Original file name |
| `id` | [`StorageObjectID!`](../scalar/storageobjectid.md) | Global ID of this StorageObject |
| `namespace` | [`Namespace!`](../object/namespace.md) | The namespace that owns the file |
| `origin` | [`String!`](../scalar/string.md) | How the file was created (user_upload, execution_output) |
| `project` | [`NamespaceProject!`](../object/namespaceproject.md) | The project that owns the file |
| `status` | [`String!`](../scalar/string.md) | pending or committed |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this StorageObject was last updated |
| `userAbilities` | [`StorageObjectUserAbilities!`](../object/storageobjectuserabilities.md) | Abilities for the current user on this StorageObject |
