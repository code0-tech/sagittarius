---
title: NodeFunctionInput
---

Input type for a Node Function

## Fields

| Name | Type | Description |
|------|------|-------------|
| `functionDefinitionId` | [`FunctionDefinitionID!`](../scalar/functiondefinitionid.md) | The identifier of the Function Definition |
| `id` | [`NodeFunctionID!`](../scalar/nodefunctionid.md) | The identifier of the Node Function used to create/update the flow |
| `nextNodeId` | [`NodeFunctionID`](../scalar/nodefunctionid.md) | The next Node Function in the flow |
| `parameters` | [`[NodeParameterInput!]!`](../input_object/nodeparameterinput.md) | The parameters of the Node Function |
