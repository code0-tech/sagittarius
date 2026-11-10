# frozen_string_literal: true

module CLOUD
  module Licenses
    # Cloud licenses belong to a namespace, so a removal concerns that namespace's
    # administrators rather than the installation's (see Licenses::NotifyRemovalService).
    module NotifyRemovalService
      include Sagittarius::Override

      protected

      # The row is already deleted, but the in-memory object still carries its namespace_id.
      override :recipients
      def recipients
        license.namespace.administrator_users.notifiable
      end
    end
  end
end
