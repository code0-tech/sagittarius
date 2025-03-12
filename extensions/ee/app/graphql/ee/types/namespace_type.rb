# frozen_string_literal: true

module EE
  module Types
    module NamespaceType
      extend ActiveSupport::Concern

      prepended do
        field :namespace_licenses, ::Types::NamespaceLicenseType.connection_type,
              null: false,
              description: 'Licenses of the namespace'
      end
    end
  end
end
