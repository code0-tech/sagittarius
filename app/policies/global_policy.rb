# frozen_string_literal: true

class GlobalPolicy < BasePolicy
  condition(:team_creation_restricted) { ApplicationSetting.current[:team_creation_restricted] }
  condition(:admin) { @user&.admin }

  rule { ~anonymous }.enable :create_team
  rule { team_creation_restricted & ~admin }.prevent :create_team

  rule { admin }.policy do
    enable :read_application_setting
    enable :update_application_setting
  end
end
