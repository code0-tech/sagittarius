# frozen_string_literal: true

module EE
  module OrganizationPolicy
    extend ActiveSupport::Concern

    prepended do
      customizable_permission :read_organization_license
      customizable_permission :create_organization_license
      customizable_permission :delete_organization_license
    end
  end
end
