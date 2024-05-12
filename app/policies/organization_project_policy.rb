# frozen_string_literal: true

class OrganizationProjectPolicy < BasePolicy
  include CustomizablePermission

  organization_resolver { |organization_project| organization_project.organization }

  customizable_permission :read_organization_project

end
