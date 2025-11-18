---
title: NodeFunctionInput
---

Input type for a Node Function

## Fields

| Name | Type | Description |
|------|------|-------------|
| `id` | [`NodeFunctionID!`](../scalar/nodefunctionid.md) | The identifier of the Node Function used to create/update the flow |
| `nextNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The next Node Function in the flow |
| `parameters` | [`[NodeParameterInput!]!`](../input_object/nodeparameterinput.md) | The parameters of the Node Function |
| `runtimeFunctionId` | [`RuntimeFunctionDefinitionID!`](../scalar/runtimefunctiondefinitionid.md) | The identifier of the Runtime Function Definition |
