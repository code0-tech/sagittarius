# frozen_string_literal: true

module EE
  module Types
    module MutationType
      extend ActiveSupport::Concern

      prepended do
        mount_mutation Mutations::NamespaceLicenses::Create
        mount_mutation Mutations::NamespaceLicenses::Delete
      end
    end
  end
end
