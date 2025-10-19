import type {CodegenConfig} from '@graphql-codegen/cli';
import {readFileSync,writeFileSync} from "node:fs";


type Type = { kind: string; name?: string; ofType?: Type };
type Schema = {
  data: {
    __schema: {
      types: Array<{
        kind: string;
        name: string;
        fields: Array<{ type: Type }>
      }>;
    };
  };
}

const schemaData = readFileSync('../../../tmp/schema.json', 'utf-8');
const schema: Schema = JSON.parse(schemaData);

schema.data.__schema.types.forEach(type => {
  type.fields?.forEach(field => {
    if(field.type.kind == "NON_NULL") {
      field.type = field.type.ofType
    }
  })
})

writeFileSync('../../../tmp/schema-nullable.json', JSON.stringify(schema), { encoding: 'utf-8' });

const globalIds = schema.data.__schema.types
  .filter(type => type.kind === 'SCALAR' && type.name.endsWith('ID'))

const scalars = {
  JSON: {
    input: 'any',
    output: 'any',
  },
  Time: {
    input: 'string',
    output: 'string',
  }
}


globalIds.forEach(type => {
  const typeConfig = `\`gid://sagittarius/${type.name.replace(/ID$/, '')}/\${number}\``

  scalars[type.name] = {
    input: typeConfig,
    output: typeConfig,
  };
});


const config: CodegenConfig = {
  schema: "../../../tmp/schema-nullable.json",
  generates: {
    './index.d.ts': {
      plugins: [
        "typescript"
      ],
      config: {
        scalars,
        strictScalars: true,
        declarationKind: 'interface',
      }
    },
  },
};


export default config;
