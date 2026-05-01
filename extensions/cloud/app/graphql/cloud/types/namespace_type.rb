# frozen_string_literal: true

module CLOUD
  module Types
    module NamespaceType
      extend ActiveSupport::Concern

      prepended do
        field :licenses, ::Types::LicenseType.connection_type,
              null: false,
              description: '(Cloud only) Licenses of the namespace'

        field :current_license, ::Types::LicenseType,
              null: true,
              description: '(Cloud only) Currently active license of the namespace'

        expose_abilities %i[
          create_license
        ]
      end
    end
  end
end
