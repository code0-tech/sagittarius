import type {CodegenConfig} from '@graphql-codegen/cli';
import {readFileSync,writeFileSync} from "node:fs";


type Type = { kind: string; name?: string; ofType?: Type };
type Schema = {
  data: {
    __schema: {
      types: Array<{
        kind: string;
        name: string;
        fields: Array<{ type: Type }>;
        specifiedByURL?: string;
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
  },
  Date: {
    input: 'string',
    output: 'string',
  },
  ISO8601Date: {
    input: 'string',
    output: 'string',
  },
  BigInt: {
    input: 'number',
    output: 'number',
  }
}


globalIds.forEach(type => {
  const modelName = type.name.replace(/ID$/, '');
  const prefix = `gid://sagittarius/${modelName}/`;
  const specifiedBy = type.specifiedByURL ?? '';
  const keySuffix = specifiedBy.startsWith(prefix) ? specifiedBy.slice(prefix.length) : '';
  const idType = keySuffix.split('/').map(part => part === 'id' ? '${number}' : '${string}').join('/')

  const typeConfig = `\`gid://sagittarius/${modelName}/${idType}\``;

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
        constEnums: true
      }
    },
  },
  hooks: {
    afterAllFileWrite: () => {
      const filePath = './index.d.ts';
      let content = readFileSync(filePath, 'utf-8');
      content = content.replace(/}\s*;/g, '}');
      writeFileSync(filePath, content, { encoding: 'utf-8' });
    }
  }
};


export default config;
