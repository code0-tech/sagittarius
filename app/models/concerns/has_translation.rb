# frozen_string_literal: true

module HasTranslation
  extend ActiveSupport::Concern

  class_methods do
    # rubocop:disable Naming/PredicatePrefix -- this is an association macro, not a predicate
    def has_translation(relation, purpose: nil)
      has_many relation, -> { by_purpose(purpose) },
               class_name: 'Translation',
               as: :owner,
               inverse_of: :owner,
               autosave: true,
               dependent: :destroy
    end
    # rubocop:enable Naming/PredicatePrefix
  end
end
