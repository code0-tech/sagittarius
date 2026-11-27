# frozen_string_literal: true

module Sagittarius
  module Validators
    # Enforces the password policy for user chosen passwords (registration and
    # admin user creation). The maximum length is already covered by
    # has_secure_password, so only the minimum length and the required
    # character classes are checked here.
    class PasswordValidator < ActiveModel::EachValidator
      MINIMUM_LENGTH = 8

      def validate_each(record, attribute, value)
        record.errors.add(attribute, :too_short, count: MINIMUM_LENGTH) if value.length < MINIMUM_LENGTH
        record.errors.add(attribute, :no_uppercase) unless value.match?(/[[:upper:]]/)
        record.errors.add(attribute, :no_lowercase) unless value.match?(/[[:lower:]]/)
        record.errors.add(attribute, :no_number) unless value.match?(/[[:digit:]]/)
        record.errors.add(attribute, :no_special_character) unless value.match?(/[^[:alnum:]]/)
      end
    end
  end
end
