import type {CodegenConfig} from '@graphql-codegen/cli';
import {readFileSync} from "node:fs";

type Schema = {
  data: {
    __schema: {
      types: Array<{ kind: string; name: string; }>;
    };
  };
}

const schemaData = readFileSync('../../../tmp/schema.json', 'utf-8');
const schema: Schema = JSON.parse(schemaData);

const globalIds = schema.data.__schema.types
  .filter(type => type.kind === 'SCALAR' && type.name.endsWith('ID'))

const scalarConfig = {
  scalars: {
    JSON: {
      input: 'any',
      output: 'any',
    },
    Time: {
      input: 'string',
      output: 'string',
    }
  }
}


globalIds.forEach(type => {
  const typeConfig = `\`gid://sagittarius/${type.name}/\${number}\``

  scalarConfig.scalars[type.name] = {
    input: typeConfig,
    output: typeConfig,
  };
});


const config: CodegenConfig = {
  schema: "../../../tmp/schema.graphql",
  generates: {
    './index.d.ts': {
      plugins: [
        "typescript"
      ],
      config: {
        ...scalarConfig,
        strictScalars: true,
        declarationKind: 'interface',
      }
    },
  },
};


export default config;
