---
title: ReferenceValueInput
---

Input type for reference value

## Fields

| Name | Type | Description |
|------|------|-------------|
| `inputIndex` | [`Int`](../scalar/int.md) | The index of the referenced input |
| `inputTypeIdentifier` | [`String`](../scalar/string.md) | The identifier of the input type |
| `nodeFunctionId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The referenced value unless referencing the flow input |
| `parameterIndex` | [`Int`](../scalar/int.md) | The index of the referenced parameter |
| `referencePath` | [`[ReferencePathInput!]!`](../input_object/referencepathinput.md) | The paths associated with this reference value |
