---
title: Query
---

Root Query type

## Fields without arguments

| Name | Type | Description |
|------|------|-------------|
| `application` | [`Application!`](../object/application.md) | Get application information |
| `currentAuthentication` | [`Authentication`](../union/authentication.md) | Get the currently logged in authentication |
| `currentUser` | [`User`](../object/user.md) | Get the currently logged in user |
| `globalRuntimes` | [`RuntimeConnection!`](../object/runtimeconnection.md) | Find runtimes |
| `organizations` | [`OrganizationConnection!`](../object/organizationconnection.md) | Find organizations |
| `users` | [`UserConnection!`](../object/userconnection.md) | Find users |

## Fields with arguments

### echo

Field available for use to test API access

Returns [`String!`](../scalar/string.md).

| Name | Type | Description |
|------|------|-------------|
| `message` | [`String!`](../scalar/string.md) | String to echo as response |

### namespace

Find a namespace

Returns [`Namespace`](../object/namespace.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`NamespaceID!`](../scalar/namespaceid.md) | GlobalID of the target namespace |

### organization

Find a organization

Returns [`Organization`](../object/organization.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`OrganizationID`](../scalar/organizationid.md) | GlobalID of the target organization |
| `name` | [`String`](../scalar/string.md) | Name of the target organization |

### testExecution

Find a test execution

Returns [`TestExecution`](../object/testexecution.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`TestExecutionID!`](../scalar/testexecutionid.md) | GlobalID of the target test execution |

### testExecutions

Find test executions for a flow

Returns [`TestExecutionConnection!`](../object/testexecutionconnection.md).

| Name | Type | Description |
|------|------|-------------|
| `after` | [`String`](../scalar/string.md) | Returns the elements in the list that come after the specified cursor. |
| `before` | [`String`](../scalar/string.md) | Returns the elements in the list that come before the specified cursor. |
| `first` | [`Int`](../scalar/int.md) | Returns the first _n_ elements from the list. |
| `flowId` | [`FlowID!`](../scalar/flowid.md) | GlobalID of the flow to find test executions for |
| `last` | [`Int`](../scalar/int.md) | Returns the last _n_ elements from the list. |

### user

Find a user

Returns [`User`](../object/user.md).

| Name | Type | Description |
|------|------|-------------|
| `id` | [`UserID`](../scalar/userid.md) | GlobalID of the target user |
| `username` | [`String`](../scalar/string.md) | Username of the target user (case insensitive) |
