# frozen_string_literal: true

require_relative '../../../file_helpers'

module RuboCop
  module Cop
    module Sagittarius
      module Migration
        class CreateTableWithTimestamps < RuboCop::Cop::Base
          include RuboCop::FileHelpers

          MSG = 'Add timestamps when creating a new table.'
          RESTRICT_ON_SEND = %i[create_table].freeze

          def_node_matcher :create_table_with_timestamps_proc?, <<~PATTERN
            (send nil? :create_table (sym _) ... (block-pass (sym :timestamps_with_timezone)))
          PATTERN

          def_node_search :timestamps_included?, <<~PATTERN
            (send _var :timestamps_with_timezone ...)
          PATTERN

          def_node_search :created_at_included?, <<~PATTERN
            (send _var :datetime_with_timezone
              {(sym :created_at)(str "created_at")}
              ...)
          PATTERN

          def_node_search :updated_at_included?, <<~PATTERN
            (send _var :datetime_with_timezone
              {(sym :updated_at)(str "updated_at")}
              ...)
          PATTERN

          def_node_matcher :create_table_with_block?, <<~PATTERN
            (block
              (send nil? :create_table ...)
              (args (arg _var)+)
              _)
          PATTERN

          def on_send(node)
            return unless in_migration?(node)
            return unless node.command?(:create_table)

            parent = node.parent

            if create_table_with_block?(parent)
              add_offense(parent) if parent.body.nil? || !time_columns_included?(parent.body)
            elsif create_table_with_timestamps_proc?(node)
              # nothing to do
            else
              add_offense(node)
            end
          end

          private

          def time_columns_included?(node)
            timestamps_included?(node) || created_at_and_updated_at_included?(node)
          end

          def created_at_and_updated_at_included?(node)
            created_at_included?(node) && updated_at_included?(node)
          end
        end
      end
    end
  end
end
