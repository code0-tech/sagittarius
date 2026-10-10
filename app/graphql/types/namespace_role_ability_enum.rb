# frozen_string_literal: true

module Types
  class NamespaceRoleAbilityEnum < BaseEnum
    description 'Represents abilities that can be granted to roles in namespaces.'

    NamespaceRoleAbility::ABILITIES.each do |ability, settings|
      value ability.upcase, settings[:description],
            value: ability,
            deprecation_reason: settings.fetch(:deprecation_reason, nil)
    end
  end
end
