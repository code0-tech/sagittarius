const GRAPHQL_URL = process.env.GRAPHQL_URL || 'http://localhost:3000/graphql';
const CABLE_URL = process.env.CABLE_URL || 'ws://localhost:3000/cable';
const TOKEN = process.env.TOKEN || 'Admin';
const AUTHORIZATION = TOKEN.includes(' ') ? TOKEN : `Session ${TOKEN}`;

const GENERATE_FIELD = process.env.GENERATE_FIELD || 'aiGenerateFlow';
const ID_FIELD = process.env.ID_FIELD || (GENERATE_FIELD === 'aiGenerateFlow' ? 'executionIdentifier' : 'id');
const SUBSCRIPTION_ID_ARG = process.env.SUBSCRIPTION_ID_ARG || ID_FIELD;
const INPUT_TYPE = process.env.INPUT_TYPE || (GENERATE_FIELD === 'aiGenerateFlow'
  ? 'AiGenerateFlowInput'
  : 'VelorumGenerateFlowInput');
const FLOW_SELECTION = process.env.FLOW_SELECTION || (GENERATE_FIELD === 'aiGenerateFlow'
  ? `flow {
      name
      type
      startingNodeId
      settings {
        id
        flowSettingId
        value
        cast
      }
      nodes {
        id
        functionDefinition {
          id
          identifier
        }
        functionIdentifier
        definitionSource
        nextNodeId
        parameters {
          id
          parameterDefinitionId
          parameterIdentifier
          cast
          value {
            literalValue
            referenceValue {
              flowInput
              nodeId
              nodeFunctionId
              inputType {
                nodeId
                parameterIndex
                inputIndex
              }
              parameterIndex
              inputIndex
              referencePath {
                path
                arrayIndex
              }
            }
            subFlow {
              startingNodeId
              functionIdentifier
              signature
              settings {
                identifier
                defaultValue
                optional
                hidden
              }
            }
            subFlowValue {
              startingNodeId
              functionIdentifier
              signature
              settings {
                identifier
                defaultValue
                optional
                hidden
              }
            }
          }
        }
      }
    }`
  : 'flow');

const PROJECT_ID = process.env.PROJECT_ID || 'gid://sagittarius/NamespaceProject/1';
const MODEL_IDENTIFIER = process.env.MODEL_IDENTIFIER || 'gpt-oss-120b';
const PROMPT = process.env.PROMPT || 'Create a simple flow that fetches data from the GitHub issue API.';

const WebSocketImpl = globalThis.WebSocket || require('ws');
const identifier = JSON.stringify({ channel: 'GraphqlChannel', token: AUTHORIZATION });

async function createGeneration() {
  const mutation = `
    mutation GenerateFlow($input: ${INPUT_TYPE}!) {
      ${GENERATE_FIELD}(input: $input) {
        ${ID_FIELD}
        errors {
          errorCode
          details {
            ... on MessageError { message }
            ... on ActiveModelError { attribute type }
          }
        }
      }
    }
  `;

  const response = await fetch(GRAPHQL_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: AUTHORIZATION,
    },
    body: JSON.stringify({
      query: mutation,
      variables: {
        input: {
          projectId: PROJECT_ID,
          prompt: PROMPT,
          modelIdentifier: MODEL_IDENTIFIER,
        },
      },
    }),
  });

  const rawBody = await response.text();
  let body;
  try {
    body = rawBody ? JSON.parse(rawBody) : null;
  } catch (error) {
    throw new Error(`Mutation returned non-JSON HTTP ${response.status}: ${rawBody}`);
  }

  if (!response.ok || body === null || typeof body !== 'object') {
    throw new Error(`Mutation returned HTTP ${response.status}: ${rawBody || '<empty body>'}`);
  }

  console.log('Mutation response:', JSON.stringify(body, null, 2));

  if (body.errors?.length) {
    throw new Error(`GraphQL mutation failed: ${JSON.stringify(body.errors)}`);
  }

  const payload = body.data?.[GENERATE_FIELD];
  if (payload?.errors?.length) {
    throw new Error(`Generation mutation returned errors: ${JSON.stringify(payload.errors)}`);
  }

  const id = payload?.[ID_FIELD];
  if (!id) {
    throw new Error(`Generation mutation did not return ${ID_FIELD}`);
  }

  return id;
}

function subscribeToGeneration(id) {
  const ws = new WebSocketImpl(CABLE_URL);

  ws.onopen = () => {
    ws.send(JSON.stringify({
      command: 'subscribe',
      identifier,
    }));
  };

  ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    if (data.type === 'ping') return;

    console.log('Received:', JSON.stringify(data, null, 2));

    if (data.type === 'confirm_subscription') {
      ws.send(JSON.stringify({
        command: 'message',
        identifier,
        data: JSON.stringify({
          action: 'execute',
          query: `
            subscription GeneratedFlow($id: String!) {
              ${GENERATE_FIELD}(${SUBSCRIPTION_ID_ARG}: $id) {
                ${FLOW_SELECTION}
              }
            }
          `,
          variables: { id },
        }),
      }));
    }

    if (data.message?.more === false) {
      ws.close();
    }
  };

  ws.onerror = (event) => console.error('WS error:', event);
  ws.onclose = (event) => console.log('WS closed:', event.code, event.reason);
}

createGeneration()
  .then((id) => {
    console.log(`Subscribing to generation id: ${id}`);
    subscribeToGeneration(id);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
