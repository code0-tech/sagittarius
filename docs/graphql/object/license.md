---
title: License
---

(EE only) Represents a License

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this License was created |
| `endDate` | [`Time`](../scalar/time.md) | The end date of the license |
| `id` | [`LicenseID!`](../scalar/licenseid.md) | Global ID of this License |
| `licensee` | [`JSON!`](../scalar/json.md) | The licensee information |
| `namespace` | [`Namespace!`](../object/namespace.md) | (Cloud only) The namespace the license belongs to |
| `startDate` | [`Time!`](../scalar/time.md) | The start date of the license |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this License was last updated |
| `userAbilities` | [`LicenseUserAbilities!`](../object/licenseuserabilities.md) | Abilities for the current user on this License |
