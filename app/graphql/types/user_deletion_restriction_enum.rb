# frozen_string_literal: true

module Types
  class UserDeletionRestrictionEnum < Types::BaseEnum
    description 'The reason why a user cannot be deleted.'

    value 'LAST_ADMINISTRATOR',
          'The user is the last administrator of the instance.',
          value: :last_administrator
  end
end

Types::UserDeletionRestrictionEnum.prepend_extensions
