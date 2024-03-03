# frozen_string_literal: true

module Types
  class TeamRoleAbilityEnum < BaseEnum
    description 'Represents abilities that can be granted to roles in teams.'

    TeamRoleAbility::ABILITIES.each do |ability, settings|
      value ability.upcase, settings[:description], value: ability, **settings.except(:db, :description)
    end
  end
end
