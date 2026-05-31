---
title: TestExecutionNodeResult
---

Represents a node result of a test execution

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this TestExecutionNodeResult was created |
| `error` | [`JSON`](../scalar/json.md) | Error returned by this node execution |
| `finishedAt` | [`Time`](../scalar/time.md) | Time when this node execution finished |
| `id` | [`TestExecutionNodeResultID!`](../scalar/testexecutionnoderesultid.md) | Global ID of this TestExecutionNodeResult |
| `nodeFunction` | [`NodeFunction`](../object/nodefunction.md) | Node function associated with this result |
| `nodeId` | [`String!`](../scalar/string.md) | Runtime node identifier returned by Tucana |
| `parameterResults` | [`TestExecutionParameterResultConnection!`](../object/testexecutionparameterresultconnection.md) | Parameter results produced by this node execution |
| `position` | [`Int!`](../scalar/int.md) | Position of this node result in the execution result |
| `startedAt` | [`Time`](../scalar/time.md) | Time when this node execution started |
| `success` | [`JSON`](../scalar/json.md) | Successful value returned by this node execution |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this TestExecutionNodeResult was last updated |
