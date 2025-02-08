# frozen_string_literal: true

module EE
  module NamespacePolicy
    extend ActiveSupport::Concern

    prepended do
      customizable_permission :read_namespace_license
      customizable_permission :create_namespace_license
      customizable_permission :delete_namespace_license
    end
  end
end
