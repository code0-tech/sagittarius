# frozen_string_literal: true

class RuntimeFeature < ApplicationRecord
  include HasTranslation

  belongs_to :runtime_status, inverse_of: :runtime_features

  has_translation :names, purpose: :name
  has_translation :descriptions, purpose: :description
end
