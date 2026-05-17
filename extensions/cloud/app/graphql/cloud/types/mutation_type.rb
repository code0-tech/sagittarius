# frozen_string_literal: true

module CLOUD
  module Types
    module MutationType
      extend ActiveSupport::Concern

      prepended do
        mount_mutation Mutations::Namespaces::Licenses::Create
        mount_mutation Mutations::Namespaces::Licenses::Delete
        mount_mutation Mutations::Users::CreateCraterToken
      end
    end
  end
end
