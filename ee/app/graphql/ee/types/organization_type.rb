# frozen_string_literal: true

module EE
  module Types
    module OrganizationType
      extend ActiveSupport::Concern

      prepended do
        field :organization_licenses, ::Types::OrganizationLicenseType.connection_type,
              null: false,
              description: 'Licenses of the organization'
      end
    end
  end
end
