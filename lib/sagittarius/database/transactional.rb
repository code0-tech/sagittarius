# frozen_string_literal: true

module Sagittarius
  module Database
    module Transactional
      module_function

      def transactional
        return_value = nil

        ActiveRecord::Base.transaction do
          return_value = yield
        end

        return_value
      end
    end
  end
end
