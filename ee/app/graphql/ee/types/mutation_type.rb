# frozen_string_literal: true

module EE
  module Types
    module MutationType
      extend ActiveSupport::Concern

      prepended do
        mount_mutation Mutations::OrganizationLicenses::Create
      end
    end
  end
end
