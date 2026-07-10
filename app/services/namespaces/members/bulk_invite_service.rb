# frozen_string_literal: true

module Namespaces
  module Members
    class BulkInviteService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace, :users

      def initialize(current_authentication, namespace, users)
        @current_authentication = current_authentication
        @namespace = namespace
        @users = users
      end

      def execute
        transactional do |transaction|
          namespace_members = users.map do |user|
            response = InviteService.new(current_authentication, namespace, user).execute
            transaction.rollback_and_return!(response) if response.error?

            response.payload
          end

          ServiceResponse.success(message: 'Namespace members invited', payload: namespace_members)
        end
      end
    end
  end
end
