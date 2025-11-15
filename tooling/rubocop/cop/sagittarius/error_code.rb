# frozen_string_literal: true

module RuboCop
  module Cop
    module Sagittarius
      class ErrorCode < RuboCop::Cop::Base
        MSG = 'Error code %s doesnt exist.'

        def_node_matcher :is_service_error?, <<~PATTERN
          (send (const _ :ServiceResponse) :error ...)
        PATTERN

        def on_send(node)
          return unless in_service?(node)
          return unless is_service_error?(node)

          node.children.each do |child|
            next unless child.is_a?(RuboCop::AST::HashNode)

            child.children.each do |child_child|
              next unless child_child.is_a?(RuboCop::AST::PairNode)
              next unless child_child.children[0].sym_type?
              next unless child_child.children[1].sym_type?
              next unless child_child.children[0].value == :error_code

              code = child_child.children[1].value
              add_offense(child_child.children[1], message: MSG % ":#{code}") unless exists_error_code?(code)
            end
          end
        end

        def exists_error_code?(code)
          @exists_error_code ||= extract_all_error_codes

          @exists_error_code.include?(code)
        end

        def extract_error_code_hash_from_ast(ast)
          return {} unless ast

          method_defs = ast.each_node(:def, :defs).select do |node|
            node.method_name == :error_codes
          end

          return {} if method_defs.empty?

          # Collect all hash literals returned by these methods
          hash_nodes = method_defs.filter_map do |m|
            body = m.body
            next unless body

            # The body can be:
            #   - a literal hash
            #   - a call to `super.merge({ ... })`
            if body.hash_type?
              body
            elsif body.send_type? && body.method_name == :merge
              merge_arg = body.arguments.first
              merge_arg if merge_arg&.hash_type?
            end
          end

          hash_nodes.flat_map(&:pairs).each_with_object({}) do |pair, h|
            key = pair.key
            next unless key.sym_type?

            h[key.value] = pair.value
          end
        end

        def extract_all_error_codes
          files = Dir.glob("#{__dir__}/../../../../**/app/services/**/error_code.rb")

          merged = {}

          files.each do |path|
            next unless File.exist?(path)

            ast = RuboCop::ProcessedSource.new(File.read(path), RUBY_VERSION.to_f).ast
            partial = extract_error_code_hash_from_ast(ast)
            merged.merge!(partial) # child overrides parent, matches super.merge behavior
          end

          merged.keys
        end

        def dirname(node)
          File.dirname(filepath(node))
        end

        def basename(node)
          File.basename(filepath(node))
        end

        def filepath(node)
          node.location.expression.source_buffer.name
        end

        def in_mutation?(node)
          dirname(node).include?('app/mutations') # .include? because the path is ../app/mutations/...
        end

        def in_service?(node)
          dirname(node).include?('app/services') # .include? because the path is ../app/services/...
        end
      end
    end
  end
end
