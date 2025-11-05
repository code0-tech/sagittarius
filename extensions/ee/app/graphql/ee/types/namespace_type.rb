# frozen_string_literal: true

module EE
  module Types
    module NamespaceType
      extend ActiveSupport::Concern

      prepended do
        field :namespace_licenses, ::Types::NamespaceLicenseType.connection_type,
              null: false,
              description: '(EE only) Licenses of the namespace'

        expose_abilities %i[
          create_namespace_license
        ]
      end
    end
  end
end
