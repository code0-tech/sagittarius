# frozen_string_literal: true

require_relative '../../../file_helpers'

module RuboCop
  module Cop
    module Sagittarius
      module Migration
        # Cop that checks if 'timestamps' method is called with timezone information.
        class Timestamps < RuboCop::Cop::Base
          include RuboCop::FileHelpers
          extend AutoCorrector

          MSG = 'Do not use `timestamps`, use `timestamps_with_timezone` instead'

          # Check methods in table creation.
          def on_def(node)
            return unless in_migration?(node)

            node.each_descendant(:send) do |send_node|
              next unless method_name(send_node) == :timestamps

              add_offense(send_node.loc.selector) do |corrector|
                corrector.replace(send_node.loc.selector, 'timestamps_with_timezone')
              end
            end
          end

          def method_name(node)
            node.children[1]
          end
        end
      end
    end
  end
end
