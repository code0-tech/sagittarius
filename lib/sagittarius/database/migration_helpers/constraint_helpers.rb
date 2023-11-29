# frozen_string_literal: true

module Sagittarius
  module Database
    module MigrationHelpers
      module ConstraintHelpers
        def text_limit_name(table, column, name: nil)
          name.presence || check_constraint_name(table, column, 'max_length')
        end

        def check_constraint_name(table, column, type)
          identifier = "#{table}_#{column}_check_#{type}"
          hashed_identifier = Digest::SHA256.hexdigest(identifier).first(10)

          "check_#{hashed_identifier}"
        end
      end
    end
  end
end
