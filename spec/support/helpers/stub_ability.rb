# frozen_string_literal: true

module StubAbility
  InvalidAbility = Class.new(StandardError)

  def stub_allowed_ability(policy_class, ability, user: nil, subject: nil)
    raise InvalidAbility, "Ability #{ability} does not exist" unless NamespaceRoleAbility::ABILITIES.key?(ability)

    # rubocop:disable RSpec/AnyInstance -- policy instances are per user and subject
    allow_any_instance_of(policy_class)
      .to receive(:user_has_ability?)
      .with(ability, user, subject)
      .and_return(true)
    # rubocop:enable RSpec/AnyInstance
  end
end

RSpec.configure do |config|
  config.include StubAbility
end
