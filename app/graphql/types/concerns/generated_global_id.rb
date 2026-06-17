# frozen_string_literal: true

module Types
  module Concerns
    module GeneratedGlobalId
      private

      def generated_global_id(value, model_class)
        return if value.blank?
        return value if value.respond_to?(:model_class)

        GlobalID.new(
          URI::GID.build(
            app: GlobalID.app,
            model_name: model_class.name,
            model_id: value.to_s
          )
        )
      end
    end
  end
end
