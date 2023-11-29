# frozen_string_literal: true

module Sagittarius
  module Database
    module MigrationHelpers
      module IndexHelpers
        def index_name(table, column, type)
          identifier = "#{table}_#{column}_index_#{type}"
          hashed_identifier = Digest::SHA256.hexdigest(identifier).first(10)

          "index_#{hashed_identifier}"
        end
      end
    end
  end
end
