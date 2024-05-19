# frozen_string_literal: true

class OrganizationProjectPolicy < BasePolicy
  include CustomizablePermission

  organization_resolver(&:organization)

  condition(:can_create_projects) { can?(:create_organization_project, @subject.organization) }

  rule { can_create_projects }.enable :read_organization_project

  customizable_permission :read_organization_project
end
