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

      customizable_permission :read_license
      customizable_permission :create_license
      customizable_permission :delete_license
    end
  end
end
