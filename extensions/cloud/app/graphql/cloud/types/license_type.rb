# frozen_string_literal: true

module CLOUD
  module Types
    module LicenseType
      extend ActiveSupport::Concern

      prepended do
        field :namespace, ::Types::NamespaceType,
              null: false,
              description: '(Cloud only) The namespace the license belongs to'
      end
    end
  end
end
