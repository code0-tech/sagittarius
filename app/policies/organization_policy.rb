# frozen_string_literal: true

class OrganizationPolicy < BasePolicy
  include CustomizablePermission

  delegate { @subject.ensure_namespace }

  rule { can?(:read_namespace) }.enable :read_organization

  namespace_resolver(&:ensure_namespace)

  customizable_permission :update_organization
  customizable_permission :delete_organization
end
