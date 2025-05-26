# frozen_string_literal: true

class ReferenceValue < ApplicationRecord
  belongs_to :data_type_identifier
  has_many :reference_paths, inverse_of: :reference_value
  has_many :node_parameters, inverse_of: :reference_value
end
