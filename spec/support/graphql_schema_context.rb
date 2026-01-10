# frozen_string_literal: true

module SpecGraphqlSchema
  extend ActiveSupport::Concern

  class_methods do
    def types
      super({ visibility_profile: :full })
    end
  end
end

SagittariusSchema.prepend SpecGraphqlSchema
