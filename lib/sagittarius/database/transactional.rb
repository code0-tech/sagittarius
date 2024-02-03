# frozen_string_literal: true

module Sagittarius
  module Database
    module Transactional
      module_function

      def transactional
        outer_helper = TransactionContext.current_helper

        return_value = nil
        reraise_rollback = false

        helper = TransactionHelper.new
        TransactionContext.current_helper = helper

        ActiveRecord::Base.transaction do
          return_value = yield helper
        rescue ActiveRecord::Rollback => e
          raise e if outer_helper.nil?

          reraise_rollback = true
        end

        TransactionContext.current_helper = outer_helper

        outer_helper.rollback_and_return! helper.return_value if reraise_rollback
        return_value || helper.return_value
      end

      class TransactionHelper
        attr_reader :return_value

        def rollback_and_return!(value)
          @return_value = value
          raise ActiveRecord::Rollback
        end
      end

      class TransactionContext < ActiveSupport::CurrentAttributes
        attribute :current_helper
      end
    end
  end
end
