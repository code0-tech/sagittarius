# frozen_string_literal: true

module RuboCop
  module Cop
    module Sagittarius
      module Logs
        # Cop that checks if 'timestamps' method is called with timezone information.
        class RailsLogger < RuboCop::Cop::Base
          MSG = 'Do not use `Rails.logger` directly, include `Code0::ZeroTrack::Loggable` instead'
          LOG_METHODS = %i[debug error fatal info warn].freeze
          LOG_METHODS_PATTERN = LOG_METHODS.map(&:inspect).join(' ').freeze

          def_node_matcher :rails_logger_log?, <<~PATTERN
            (send
              (send (const nil? :Rails) :logger)
              {#{LOG_METHODS_PATTERN}} ...
            )
          PATTERN

          def on_send(node)
            return unless rails_logger_log?(node)

            add_offense(node)
          end
        end
      end
    end
  end
end
