---
title: ReferenceValueInput
---

Input type for reference value

## Fields

| Name | Type | Description |
|------|------|-------------|
| `dataTypeIdentifier` | [`DataTypeIdentifierInput!`](../input_object/datatypeidentifierinput.md) | The identifier of the data type this reference value belongs to |
| `depth` | [`Int!`](../scalar/int.md) | The depth of the reference value |
| `node` | [`Int!`](../scalar/int.md) | The node of the reference |
| `nodeFunctionId` | [`NodeFunctionID!`](../scalar/nodefunctionid.md) | The referenced value |
| `referencePath` | [`[ReferencePathInput!]!`](../input_object/referencepathinput.md) | The paths associated with this reference value |
| `scope` | [`[Int!]!`](../scalar/int.md) | The scope of the reference value |
