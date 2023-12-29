# frozen_string_literal: true

module Sagittarius
  module Database
    module Transactional
      module_function

      def transactional
        return_value = nil

        helper = TransactionHelper.new
        ActiveRecord::Base.transaction do
          return_value = yield helper
        end

        return_value || helper.return_value
      end

      class TransactionHelper
        attr_reader :return_value

        def rollback_and_return!(value)
          @return_value = value
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
