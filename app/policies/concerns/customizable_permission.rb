# frozen_string_literal: true

module CustomizablePermission
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :organization_resolver_block

    def organization_resolver(&block)
      @organization_resolver_block = block
    end

    def customizable_permission(ability)
      condition(ability) { user_has_ability?(ability, @user, @subject) }

      rule { send(ability) | admin }.enable ability
    end
  end

  included do
    condition(:admin) { user_has_ability?(:organization_administrator, @user, @subject) }

    def organization(subject)
      @organization ||= self.class.organization_resolver_block.call(subject)
    end

    def organization_member(user, subject)
      @organization_member ||= organization(subject).organization_members.find_by(user: user)
    end

    def user_has_ability?(ability, user, subject)
      return false if organization_member(user, subject).nil?

      organization_member(user, subject)
        .roles
        .joins(:abilities)
        .exists?(organization_role_abilities: { ability: ability })
    end
  end
end
