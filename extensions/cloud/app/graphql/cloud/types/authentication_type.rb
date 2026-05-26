# frozen_string_literal: true

module CLOUD
  module Types
    module AuthenticationType
      extend ActiveSupport::Concern

      prepended do
        possible_types ::Types::CraterTokenType
      end

      class_methods do
        include Sagittarius::Override

        override :resolve_type
        def resolve_type(object, _ctx)
          return ::Types::CraterTokenType if object.is_a?(CLOUD::ApplicationController::CraterLoginToken)

          super
        end
      end
    end
  end
end
