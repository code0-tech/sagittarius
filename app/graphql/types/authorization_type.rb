# frozen_string_literal: true

module Types
  class AuthorizationType < BaseUnion
    description 'Objects that can present an authorization'
    possible_types UserSessionType

    def self.resolve_type(object, _ctx)
      case object
      when UserSession
        Types::UserSessionType
      else
        raise 'Unsupported AuthorizationType'
      end
    end
  end
end
