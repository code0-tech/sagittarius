# frozen_string_literal: true

require 'graphql/rake_task'

GraphQL::RakeTask.new(
  load_schema: lambda { |_|
    require_relative '../../app/graphql/sagittarius_schema'
    SagittariusSchema
  },
  idl_outfile: 'tmp/schema.graphql',
  json_outfile: 'tmp/schema.json'
)
