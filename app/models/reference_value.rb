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
    reference_value = Tucana::Shared::ReferenceValue.new(
      paths: reference_paths.map(&:to_grpc)
    )

    if node_function.nil?
      reference_value.flow_input = Tucana::Shared::FlowInput.new
    elsif parameter_index.present? && input_index.present?
      reference_value.input_type = Tucana::Shared::InputType.new(
        node_id: node_function.id,
        parameter_index: parameter_index,
        input_index: input_index
      )
    else
      reference_value.node_id = node_function.id
    end

    reference_value
  end
end
