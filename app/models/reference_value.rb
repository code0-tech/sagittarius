# frozen_string_literal: true

class ReferenceValue < ApplicationRecord
  belongs_to :node_function, optional: true # real value association
  has_many :reference_paths, inverse_of: :reference_value, autosave: true, dependent: :destroy
  has_many :node_parameters, inverse_of: :reference_value

  validate :validate_indexes

  def validate_indexes
    return if parameter_index.nil? && input_index.nil?

    errors.add(:node_function, :blank) if node_function.nil?
    errors.add(:input_index, :blank) if parameter_index.present? && input_index.nil?
    errors.add(:parameter_index, :blank) if input_index.present? && parameter_index.nil?
  end

  def to_grpc
    Tucana::Shared::ReferenceValue.new(
      node_id: node_function.id,
      paths: reference_paths.map(&:to_grpc)
    )
  end
end
