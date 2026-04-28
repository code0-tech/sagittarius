# frozen_string_literal: true

module CLOUD
  module NamespacePolicy
    extend ActiveSupport::Concern

    prepended do
      customizable_permission :read_license
      customizable_permission :create_license
      customizable_permission :delete_license
    end
  end
end
