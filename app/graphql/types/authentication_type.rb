# frozen_string_literal: true

module Types
  class AuthenticationType < BaseUnion
    description 'Objects that can present an authentication'
    possible_types UserSessionType

    def self.resolve_type(object, _ctx)
      case object
      when UserSession
        Types::UserSessionType
      else
        raise 'Unsupported AuthenticationType'
      end
    end
  end
end
