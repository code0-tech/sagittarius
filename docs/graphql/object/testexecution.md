---
title: TestExecution
---

Represents a test execution

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `body` | [`JSON`](../scalar/json.md) | Request body used to start the test execution |
| `createdAt` | [`Time!`](../scalar/time.md) | Time when this TestExecution was created |
| `error` | [`JSON`](../scalar/json.md) | Error returned by the test execution |
| `executionIdentifier` | [`String!`](../scalar/string.md) | Runtime identifier for the test execution |
| `finishedAt` | [`Time`](../scalar/time.md) | Time when this test execution finished |
| `flow` | [`Flow!`](../object/flow.md) | Flow executed by this test execution |
| `id` | [`TestExecutionID!`](../scalar/testexecutionid.md) | Global ID of this TestExecution |
| `input` | [`JSON`](../scalar/json.md) | Input recorded in the test execution result |
| `nodeResults` | [`TestExecutionNodeResultConnection!`](../object/testexecutionnoderesultconnection.md) | Node results produced by this test execution |
| `startedAt` | [`Time`](../scalar/time.md) | Time when this test execution started |
| `success` | [`JSON`](../scalar/json.md) | Successful value returned by the test execution |
| `updatedAt` | [`Time!`](../scalar/time.md) | Time when this TestExecution was last updated |
