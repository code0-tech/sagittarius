# frozen_string_literal: true

class GlobalPolicy < BasePolicy
  condition(:organization_creation_restricted) { ApplicationSetting.current[:organization_creation_restricted] }
  condition(:admin) { user&.admin }

  rule { ~anonymous }.enable :create_organization
  rule { organization_creation_restricted & ~admin }.prevent :create_organization

  rule { ~anonymous }.policy do
    enable :read_runtime
    enable :read_flow_type
    enable :read_flow_type_setting
    enable :read_metadata
  end

  rule { admin }.policy do
    enable :read_application_setting
    enable :update_application_setting
    enable :create_runtime
    enable :update_runtime
    enable :delete_runtime
    enable :rotate_runtime_token
    enable :list_users
    enable :create_user
  end
end
