# frozen_string_literal: true

module CustomizablePermission
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :team_resolver_block

    def team_resolver(&block)
      @team_resolver_block = block
    end

    def customizable_permission(ability)
      condition(ability) { user_has_ability?(ability, @user, @subject) }

      rule { send ability }.enable ability
    end
  end

  included do
    def team(subject)
      @team ||= self.class.team_resolver_block.call(subject)
    end

    def team_member(user, subject)
      @team_member ||= team(subject).team_members.find_by(user: user)
    end

    def user_has_ability?(ability, user, subject)
      return false if team_member(user, subject).nil?

      team_member(user, subject).roles.joins(:abilities).exists?(team_role_abilities: { ability: ability })
    end
  end
end
