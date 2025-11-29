# frozen_string_literal: true

module Types
  class IdentityProviderConfigType < Types::BaseUnion
    description 'Represents the configuration of an identity provider.'

    possible_types Types::OidcIdentityProviderConfigType, Types::SamlIdentityProviderConfigType

    def self.resolve_type(object, _context)
      case object[:type]
      when :saml
        Types::SamlIdentityProviderConfigType
      else
        Types::OidcIdentityProviderConfigType
      end
    end
  end
end
