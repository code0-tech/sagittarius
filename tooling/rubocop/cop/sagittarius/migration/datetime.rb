# frozen_string_literal: true

require_relative '../../../file_helpers'

module RuboCop
  module Cop
    module Sagittarius
      module Migration
        # Cop that checks if datetime data type is added with timezone information.
        class Datetime < RuboCop::Cop::Base
          include RuboCop::FileHelpers
          extend AutoCorrector

          MSG = 'Do not use the `%s` data type, use `datetime_with_timezone` instead'

          # Check methods in table creation.
          def on_def(node)
            return unless in_migration?(node)

            node.each_descendant(:send) do |send_node|
              method_name = send_node.children[1]

              next unless %i[datetime timestamp].include?(method_name)

              add_offense(send_node.loc.selector, message: format(MSG, method_name)) do |corrector|
                corrector.replace(send_node.loc.selector, 'datetime_with_timezone')
              end
            end
          end

          # Check methods.
          def on_send(node)
            return unless in_migration?(node)

            node.each_descendant do |descendant|
              next unless descendant.type == :sym

              last_argument = descendant.children.last

              next unless %i[datetime timestamp].include?(last_argument)

              add_offense(node, message: format(MSG, last_argument)) do |corrector|
                corrector.replace(node, 'datetime_with_timezone')
              end
            end
          end
        end
      end
    end
  end
end
