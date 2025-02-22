# frozen_string_literal: true

class ParameterDefinition < ApplicationRecord
  belongs_to :runtime_parameter_definition
  belongs_to :data_type

  has_many :translations, class_name: 'Translation', as: :owner
end
