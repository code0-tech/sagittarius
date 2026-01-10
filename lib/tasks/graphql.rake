# frozen_string_literal: true

require 'graphql/rake_task'

namespace :graphql do
  GraphQL::RakeTask.new(
    load_schema: lambda { |_|
      require_relative '../../app/graphql/sagittarius_schema'
      SagittariusSchema
    },
    load_context: ->(_) { { visibility_profile: :types } },
    idl_outfile: 'tmp/schema.graphql',
    json_outfile: 'tmp/schema.json',
    namespace: 'types'
  )

  GraphQL::RakeTask.new(
    load_schema: lambda { |_|
      require_relative '../../app/graphql/sagittarius_schema'
      SagittariusSchema
    },
    load_context: ->(_) { { visibility_profile: :execution } },
    idl_outfile: 'tmp/schema.graphql',
    json_outfile: 'tmp/schema.json',
    namespace: 'execution'
  )

  task compile_docs: :environment do
    require_relative '../../tooling/graphql/docs/renderer'
    Tooling::Graphql::Docs::Renderer.new(SagittariusSchema, output_dir: 'docs/graphql').write
  end

  task check_docs: :environment do
    require_relative '../../tooling/graphql/docs/renderer'
    if Tooling::Graphql::Docs::Renderer.new(SagittariusSchema, output_dir: 'docs/graphql').check
      puts 'GraphQL Documentation is up to date'
    else
      puts 'GraphQL Documentation is outdated'
    end
  end
end
