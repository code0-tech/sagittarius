# frozen_string_literal: true

class GlobalPolicy < BasePolicy
  condition(:organization_creation_restricted) { ApplicationSetting.current[:organization_creation_restricted] }
  condition(:admin) { @user&.admin }

  rule { ~anonymous }.enable :create_organization
  rule { organization_creation_restricted & ~admin }.prevent :create_organization

  rule { ~anonymous }.enable :read_runtime

  rule { admin }.policy do
    enable :read_application_setting
    enable :update_application_setting
    enable :create_runtime
    enable :update_runtime
  end
end
