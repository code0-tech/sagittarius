# frozen_string_literal: true

class RuntimeFeature < ApplicationRecord
  belongs_to :runtime_status, inverse_of: :runtime_features
  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
end
