# frozen_string_literal: true

module EE
  module Types
    module ApplicationType
      extend ActiveSupport::Concern

      prepended do
        field :licenses, ::Types::LicenseType.connection_type,
              null: false,
              description: '(EE only) Licenses of the instance'

        field :current_license, ::Types::LicenseType,
              null: true,
              description: '(EE only) Currently active license of the instance'

        expose_abilities %i[
          create_license
        ], subject_resolver: -> { :global }
      end

      def licenses
        License.all
      end

      def current_license
        License.current
      end
    end
  end
end
