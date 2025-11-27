# frozen_string_literal: true

module Runtimes
  module Grpc
    module TranslationUpdateHelper
      # This method updates or builds translation records based on the provided gRPC translations.
      # @param grpc_translations [Array<Tucana::Sagittarius::Translation>] An array of gRPC translation objects.
      # @param translation_relation [ActiveRecord::Relation] An ActiveRecord relation for the translations
      def update_translations(grpc_translations, translation_relation)
        db_translations = translation_relation.first(grpc_translations.length)
        grpc_translations.each_with_index do |translation, index|
          db_translations[index] ||= translation_relation.build
          db_translations[index].assign_attributes(code: translation.code, content: translation.content)
        end

        db_translations
      end
    end
  end
end
