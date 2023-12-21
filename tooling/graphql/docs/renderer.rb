# frozen_string_literal: true

require_relative 'helper'

module Tooling
  module Graphql
    module Docs
      class Renderer # rubocop:disable GraphQL/ObjectDescription -- this is not a graphql object
        include Tooling::Graphql::Docs::Helper

        attr_reader :schema

        def initialize(schema, output_dir:)
          @output_dir = output_dir
          @parsed_schema = GraphQLDocs::Parser.new(schema, {}).parse
          @schema = schema
        end

        def write
          file_contents = files

          FileUtils.mkdir_p(Rails.root.join(@output_dir))
          Dir.foreach(Rails.root.join(@output_dir)) do |file|
            next if %w[. .. index.md].include?(file)

            FileUtils.rm_rf(Rails.root.join(@output_dir, file))
          end

          file_contents.each do |name, content|
            filename = Rails.root.join(@output_dir, name)
            FileUtils.mkdir_p(File.dirname(filename))
            File.write(filename, content)
          end
        end

        def check
          files.all? do |name, content|
            filename = Rails.root.join(@output_dir, name)
            next false unless File.exist?(filename)

            File.read(filename) == content
          end
        end
      end
    end
  end
end
