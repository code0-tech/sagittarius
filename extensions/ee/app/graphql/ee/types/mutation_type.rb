# frozen_string_literal: true

module EE
  module Types
    module MutationType
      extend ActiveSupport::Concern

      prepended do
        mount_mutation Mutations::Namespaces::Licenses::Create
        mount_mutation Mutations::Namespaces::Licenses::Delete
      end
    end
  end
end
