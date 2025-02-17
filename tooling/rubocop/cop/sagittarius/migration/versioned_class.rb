# frozen_string_literal: true

require_relative '../../../file_helpers'

module RuboCop
  module Cop
    module Sagittarius
      module Migration
        class VersionedClass < RuboCop::Cop::Base
          include RuboCop::FileHelpers
          extend AutoCorrector

          MIGRATION_CLASS = 'Code0::ZeroTrack::Database::Migration'

          # rubocop:disable Layout/LineLength
          MSG_WRONG_BASE_CLASS = "Don't use `%<base_class>s`. Use `#{MIGRATION_CLASS}` instead.".freeze
          MSG_WRONG_VERSION = "Don't use version `%<current_version>s` of `#{MIGRATION_CLASS}`. Use version `%<allowed_version>s` instead.".freeze
          # rubocop:enable Layout/LineLength

          # rubocop:disable Style/NumericLiterals -- the ranges are dates, not numbers
          ALLOWED_MIGRATION_VERSIONS = {
            2023_11_29_17_37_16.. => 1.0,
          }.freeze
          # rubocop:enable Style/NumericLiterals

          def on_class(node)
            return unless in_migration?(node)

            return on_zerotrack_migration(node) if zerotrack_migration?(node)

            add_offense(
              node.parent_class,
              message: format(MSG_WRONG_BASE_CLASS, base_class: superclass(node))
            ) do |corrector|
              corrector.replace(node.parent_class, "#{MIGRATION_CLASS}[#{find_allowed_version(node)}]")
            end
          end

          private

          def on_zerotrack_migration(node)
            return unless wrong_migration_version?(node)

            current_version = get_migration_version(node)
            allowed_version = find_allowed_version(node)

            version_node = get_migration_version_node(node)

            add_offense(
              version_node,
              message: format(MSG_WRONG_VERSION, current_version: current_version, allowed_version: allowed_version)
            ) do |corrector|
              corrector.replace(version_node, find_allowed_version(node).to_s)
            end
          end

          def zerotrack_migration?(node)
            superclass(node) == MIGRATION_CLASS
          end

          def superclass(class_node)
            _, *others = class_node.descendants

            others.find { |node| node.const_type? && node.const_name != 'Types' }&.const_name
          end

          def wrong_migration_version?(node)
            get_migration_version(node) != find_allowed_version(node)
          end

          def get_migration_version_node(node)
            node.parent_class.arguments[0]
          end

          def get_migration_version(node)
            get_migration_version_node(node).value
          end

          def find_allowed_version(node)
            migration_version = basename(node).split('_').first.to_i
            ALLOWED_MIGRATION_VERSIONS.find do |version, _|
              version.include?(migration_version)
            end&.last
          end
        end
      end
    end
  end
end
