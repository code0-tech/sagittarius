# frozen_string_literal: true

module Types
  class UserDeletionRestrictionEnum < Types::BaseEnum
    description 'The reason why a user cannot be deleted.'

    value 'LAST_ADMINISTRATOR',
          'The user is the last administrator of the instance.',
          value: :last_administrator
    value 'ACTIVE_SUBSCRIPTION',
          'The current user has an active subscription.',
          value: :active_subscription
  end
end
