# frozen_string_literal: true

module CLOUD
  module NamespacePolicy
    extend ActiveSupport::Concern

    prepended do
      condition(:crater_user) { user&.crater? }

      rule { crater_user }.policy do
        enable :read_namespace
        enable :read_license
        enable :create_license
        enable :delete_license
      end

      # Lets crater check the real permissions of a user it is impersonating (authentication.user
      # is that user, not the crater account), scoped to their actual namespace membership.
      rule { crater & is_member }.enable :read_namespace

      rule { admin }.policy do
        enable :create_license
        enable :delete_license
      end

      customizable_permission :read_license
    end
  end
end
