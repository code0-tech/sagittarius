# frozen_string_literal: true

module Types
  class NamespaceParentType < BaseUnion
    description 'Objects that can present a namespace'
    possible_types OrganizationType

    def self.resolve_type(object, _ctx)
      case object
      when Organization
        OrganizationType
      else
        raise 'Unsupported NamespaceParentType'
      end
    end
  end
end
