# frozen_string_literal: true

module Types
  class IdentityProviderTypeEnum < Types::BaseEnum
    description 'The available identity provider types.'

    Code0::Identities::Provider.constants.each do |provider_class|
      next if provider_class == :BaseOauth

      provider_type = provider_class.to_s.downcase
      value provider_type.upcase, "Identity provider of type #{provider_type}", value: provider_type.to_sym
    end
  end
end
